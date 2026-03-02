import 'package:test/test.dart';
import 'package:smartypants/smartypants.dart';

void main() {
  group('SmartyPants', () {
    test('should replace straight quotes with smart quotes', () {
      String input = '"Hello, World!"';
      String expected = '“Hello, World!”';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should replace double hyphens with en dash', () {
      String input = 'A--B';
      String expected = 'A–B';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should replace triple hyphens with em dash', () {
      String input = 'A---B';
      String expected = 'A—B';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should replace straight apostrophes with smart apostrophes', () {
      String input = "It's a test.";
      String expected = "It’s a test.";
      expect(SmartyPants.formatText(input), expected);
    });

    test('should replace multiple spaces with a single space', () {
      String input = 'This    is    a    test.';
      String expected = 'This is a test.';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should replace ellipsis', () {
      String input = 'Hello... World!';
      String expected = 'Hello… World!';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should replace mathematical symbols', () {
      String input = 'x >= 10 and x <= 20';
      String expected = 'x ≥ 10 and x ≤ 20';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should replace arrows', () {
      String input = 'A -> B and A <-> B';
      String expected = 'A → B and A ↔ B';
      expect(SmartyPants.formatText(input), expected);
    });
  });

  group('SmartyPantsConfig per-transformation flags', () {
    // quotes

    test('quotes=false disables double quote transformation', () {
      const config = SmartyPantsConfig(quotes: false);
      expect(
        SmartyPants.formatText('"Hello, World!"', config: config),
        '"Hello, World!"',
      );
    });

    test('quotes=false disables apostrophe transformation', () {
      const config = SmartyPantsConfig(quotes: false);
      expect(
        SmartyPants.formatText("It's a test.", config: config),
        "It's a test.",
      );
    });

    test('quotes=false does not affect dashes', () {
      const config = SmartyPantsConfig(quotes: false);
      expect(SmartyPants.formatText('A--B', config: config), 'A\u2013B');
    });

    // dashes

    test('dashes=false disables en dash transformation', () {
      const config = SmartyPantsConfig(dashes: false);
      expect(SmartyPants.formatText('A--B', config: config), 'A--B');
    });

    test('dashes=false disables em dash transformation', () {
      const config = SmartyPantsConfig(dashes: false);
      expect(SmartyPants.formatText('A---B', config: config), 'A---B');
    });

    test('dashes=false does not affect quotes', () {
      const config = SmartyPantsConfig(dashes: false);
      expect(
        SmartyPants.formatText('"Hello"', config: config),
        '\u201CHello\u201D',
      );
    });

    // ellipsis

    test('ellipsis=false disables ASCII ellipsis transformation', () {
      const config = SmartyPantsConfig(ellipsis: false);
      expect(SmartyPants.formatText('Hello...', config: config), 'Hello...');
    });

    test('ellipsis=false does not affect dashes', () {
      const config = SmartyPantsConfig(ellipsis: false);
      expect(SmartyPants.formatText('A--B', config: config), 'A\u2013B');
    });

    // mathSymbols

    test('mathSymbols=false disables >= transformation', () {
      const config = SmartyPantsConfig(mathSymbols: false);
      expect(SmartyPants.formatText('x >= 10', config: config), 'x >= 10');
    });

    test('mathSymbols=false disables <= transformation', () {
      const config = SmartyPantsConfig(mathSymbols: false);
      expect(SmartyPants.formatText('y <= 20', config: config), 'y <= 20');
    });

    test('mathSymbols=false disables != transformation', () {
      const config = SmartyPantsConfig(mathSymbols: false);
      expect(SmartyPants.formatText('a != b', config: config), 'a != b');
    });

    test('mathSymbols=false does not affect arrows', () {
      const config = SmartyPantsConfig(mathSymbols: false);
      expect(
        SmartyPants.formatText('A -> B', config: config),
        'A \u2192 B',
      );
    });

    // arrows

    test('arrows=false disables right arrow transformation', () {
      const config = SmartyPantsConfig(arrows: false);
      expect(SmartyPants.formatText('A -> B', config: config), 'A -> B');
    });

    test('arrows=false disables left arrow transformation', () {
      const config = SmartyPantsConfig(arrows: false);
      expect(SmartyPants.formatText('B <- A', config: config), 'B <- A');
    });

    test('arrows=false disables bidirectional arrow transformation', () {
      const config = SmartyPantsConfig(arrows: false);
      expect(SmartyPants.formatText('A <-> B', config: config), 'A <-> B');
    });

    test('arrows=false disables fat arrow transformation', () {
      const config = SmartyPantsConfig(arrows: false);
      expect(
        SmartyPants.formatText('cond => result', config: config),
        'cond => result',
      );
    });

    test('arrows=false does not affect mathSymbols', () {
      const config = SmartyPantsConfig(arrows: false);
      expect(SmartyPants.formatText('x >= 10', config: config), 'x \u2265 10');
    });

    // whitespaceNormalization

    test('whitespaceNormalization=false preserves multiple spaces', () {
      const config = SmartyPantsConfig(whitespaceNormalization: false);
      expect(
        SmartyPants.formatText('Hello   World', config: config),
        'Hello   World',
      );
    });

    test('whitespaceNormalization=false does not affect quotes', () {
      const config = SmartyPantsConfig(whitespaceNormalization: false);
      expect(
        SmartyPants.formatText('"Hello"', config: config),
        '\u201CHello\u201D',
      );
    });

    // combinations

    test('quotes and dashes can be independently disabled', () {
      const config = SmartyPantsConfig(quotes: false, dashes: false);
      expect(
        SmartyPants.formatText('"Hello" -- World...', config: config),
        '"Hello" -- World\u2026',
      );
    });

    test('all flags false except ellipsis', () {
      const config = SmartyPantsConfig(
        quotes: false,
        dashes: false,
        mathSymbols: false,
        arrows: false,
        whitespaceNormalization: false,
        cjkEllipsisNormalization: false,
        cjkAngleBrackets: false,
      );
      expect(
        SmartyPants.formatText('"Hello"  -- World... -> end', config: config),
        '"Hello"  -- World\u2026 -> end',
      );
    });

    test('smart=false overrides all individual flags', () {
      const config = SmartyPantsConfig(
        smart: false,
        quotes: true,
        dashes: true,
        ellipsis: true,
        mathSymbols: true,
        arrows: true,
      );
      expect(
        SmartyPants.formatText('"Hello" -- World...', config: config),
        '"Hello" -- World...',
      );
    });

    // copyWith

    test('copyWith preserves unchanged fields', () {
      const original = SmartyPantsConfig(
        locale: SmartyPantsLocale.ko,
        dashes: false,
      );
      final copy = original.copyWith(ellipsis: false);
      expect(copy.locale, SmartyPantsLocale.ko);
      expect(copy.dashes, false);
      expect(copy.ellipsis, false);
      expect(copy.quotes, true);
    });

    test('copyWith can re-enable a disabled flag', () {
      const original = SmartyPantsConfig(dashes: false);
      final copy = original.copyWith(dashes: true);
      expect(copy.dashes, true);
      expect(
        SmartyPants.formatText('A--B', config: copy),
        'A\u2013B',
      );
    });
  });

  group('SmartyPantsConfig default backward compatibility', () {
    test('default config produces same output as explicit all-true config', () {
      const inputs = [
        '"Hello, World!"',
        "It's a test.",
        'A--B',
        'A---B',
        'Hello...',
        'x >= 10',
        'A -> B',
        'This  is  spaced',
      ];
      final defaultConfig = const SmartyPantsConfig();
      const allTrueConfig = SmartyPantsConfig(
        smart: true,
        quotes: true,
        dashes: true,
        ellipsis: true,
        mathSymbols: true,
        arrows: true,
        whitespaceNormalization: true,
        cjkEllipsisNormalization: true,
        cjkAngleBrackets: true,
      );
      for (final input in inputs) {
        expect(
          SmartyPants.formatText(input, config: defaultConfig),
          SmartyPants.formatText(input, config: allTrueConfig),
          reason: 'Input "$input" differs between default and all-true config',
        );
      }
    });
  });
}
