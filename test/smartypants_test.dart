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

  group('Locale-specific quote styles', () {
    test('en locale (default) produces English curly quotes', () {
      expect(
        SmartyPants.formatText('"Hello"'),
        '\u201CHello\u201D',
      );
    });

    test('fr locale produces guillemet quotes', () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.fr);
      expect(
        SmartyPants.formatText('"Bonjour"', config: config),
        '\u00ABBonjour\u00BB',
      );
    });

    test('de locale produces low-high quotes', () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.de);
      expect(
        SmartyPants.formatText('"Hallo"', config: config),
        '\u201EHallo\u201C',
      );
    });

    test('ko locale produces CJK corner bracket quotes', () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.ko);
      expect(
        SmartyPants.formatText('"안녕"', config: config),
        '\u300C안녕\u300D',
      );
    });

    test('ja locale produces CJK corner bracket quotes', () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.ja);
      expect(
        SmartyPants.formatText('"こんにちは"', config: config),
        '\u300Cこんにちは\u300D',
      );
    });

    test('zhHant locale produces CJK corner bracket quotes', () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.zhHant);
      expect(
        SmartyPants.formatText('"你好"', config: config),
        '\u300C你好\u300D',
      );
    });

    test('zhHans locale produces English curly quotes', () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.zhHans);
      expect(
        SmartyPants.formatText('"你好"', config: config),
        '\u201C你好\u201D',
      );
    });

    test('customQuoteStyle overrides locale default', () {
      const config = SmartyPantsConfig(
        locale: SmartyPantsLocale.fr,
        customQuoteStyle: QuoteStyle.english,
      );
      expect(
        SmartyPants.formatText('"Hi"', config: config),
        '\u201CHi\u201D',
      );
    });

    test('customQuoteStyle accepts arbitrary characters', () {
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(open: '[', close: ']'),
      );
      expect(
        SmartyPants.formatText('"Hi"', config: config),
        '[Hi]',
      );
    });

    test('copyWith preserves customQuoteStyle when not provided', () {
      const original = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle.french,
      );
      final copy = original.copyWith(dashes: false);
      expect(copy.customQuoteStyle, QuoteStyle.french);
      expect(
        SmartyPants.formatText('"Hi"', config: copy),
        '\u00ABHi\u00BB',
      );
    });

    test('custom single-quote style is not clobbered by apostrophe replacement',
        () {
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(open: "'", close: "'"),
      );
      expect(
        SmartyPants.formatText('"Hi"', config: config),
        "'Hi'",
      );
    });

    test(
        'customQuoteStyle delimiter containing "--" is not mutated by dash pass',
        () {
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(open: '--', close: '--'),
      );
      expect(
        SmartyPants.formatText('"x"', config: config),
        '--x--',
      );
    });

    test(
        'customQuoteStyle delimiter containing "->" is not mutated by arrow pass',
        () {
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(open: '->', close: '<-'),
      );
      expect(
        SmartyPants.formatText('"x"', config: config),
        '->x<-',
      );
    });

    test(
        'customQuoteStyle delimiter containing \\uFFFC (HTML placeholder) '
        'is preserved literally', () {
      // \uFFFC is the HTML-token placeholder used internally; a delimiter
      // containing it must not be consumed by the restore loop.
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(open: '\uFFFC', close: '\uFFFC'),
      );
      expect(
        SmartyPants.formatText('"x"', config: config),
        '\uFFFCx\uFFFC',
      );
    });

    test(
        'customQuoteStyle delimiter containing \\uE001 (double-angle marker) '
        'is preserved literally', () {
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(open: '\uE001', close: '\uE001'),
      );
      expect(
        SmartyPants.formatText('"x"', config: config),
        '\uE001x\uE001',
      );
    });

    test(
        'customQuoteStyle delimiter containing \\uE002 (marker escape) '
        'is preserved literally', () {
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(open: '\uE002', close: '\uE002'),
      );
      expect(
        SmartyPants.formatText('"x"', config: config),
        '\uE002x\uE002',
      );
    });

    test(
        'customQuoteStyle delimiter containing \\uE000 (escape char) '
        'is preserved literally', () {
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(open: '\uE000', close: '\uE000'),
      );
      expect(
        SmartyPants.formatText('"x"', config: config),
        '\uE000x\uE000',
      );
    });

    test(
        'customQuoteStyle sentinel delimiters are preserved alongside HTML tags',
        () {
      // \uFFFC is the HTML-placeholder sentinel; HTML tags must still be
      // restored correctly when the delimiter contains it.
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(open: '\uFFFC', close: '\uFFFC'),
      );
      expect(
        SmartyPants.formatText('<b>"x"</b>', config: config),
        '<b>\uFFFCx\uFFFC</b>',
      );
    });

    test('copyWith(customQuoteStyle: null) clears custom style', () {
      const original = SmartyPantsConfig(
        locale: SmartyPantsLocale.fr,
        customQuoteStyle: QuoteStyle.english,
      );
      final cleared = original.copyWith(customQuoteStyle: () => null);
      expect(cleared.customQuoteStyle, isNull);
      // After clearing, locale-driven quoting (fr → «») takes over.
      expect(
        SmartyPants.formatText('"Hi"', config: cleared),
        '\u00ABHi\u00BB',
      );
    });
  });

  group('secondary (single) quotes', () {
    test('German locale applies secondary marks inside nested single quotes',
        () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.de);
      expect(
        SmartyPants.formatText('"Er sagte \'Hallo\'"', config: config),
        '\u201EEr sagte \u201AHallo\u2018\u201C',
      );
    });

    test('French locale applies secondary marks inside nested single quotes',
        () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.fr);
      expect(
        SmartyPants.formatText('"il dit \'bonjour\'"', config: config),
        '\u00ABil dit \u2039bonjour\u203A\u00BB',
      );
    });

    test('French locale handles apostrophe inside single-quoted span', () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.fr);
      expect(
        SmartyPants.formatText('"il dit \'l\'homme\'"', config: config),
        '\u00ABil dit \u2039l\u2019homme\u203A\u00BB', // «il dit ‹l'homme›»
      );
    });

    test(
        'French locale treats apostrophe before accented letter as apostrophe not quote',
        () {
      // \w must be Unicode-aware so "é" is a word char; else ' in "l'été" becomes closing quote.
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.fr);
      expect(
        SmartyPants.formatText('"il dit \'l\'été\'"', config: config),
        '\u00ABil dit \u2039l\u2019été\u203A\u00BB', // «il dit ‹l'été›»
      );
    });

    test('English locale handles apostrophe inside single-quoted span', () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.en);
      expect(
        SmartyPants.formatText('"He said \'it\'s great\'"', config: config),
        '\u201CHe said \u2018it\u2019s great\u2019\u201D', // "He said 'it's great'"
      );
    });

    test('English locale applies secondary marks inside nested single quotes',
        () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.en);
      expect(
        SmartyPants.formatText('"He said \'hi\'"', config: config),
        '\u201CHe said \u2018hi\u2019\u201D',
      );
    });

    test(
        'Japanese locale applies CJK secondary marks inside nested single quotes',
        () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.ja);
      expect(
        SmartyPants.formatText('"nested \'text\'"', config: config),
        '\u300Cnested \u300Etext\u300F\u300D',
      );
    });

    test('custom style with secondaryOpen/secondaryClose uses them', () {
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(
          open: '[',
          close: ']',
          secondaryOpen: '{',
          secondaryClose: '}',
        ),
      );
      expect(
        SmartyPants.formatText('"a \'b\' c"', config: config),
        '[a {b} c]',
      );
    });

    test(
        'custom secondary quote delimiters ASCII apostrophe are preserved from apostrophe pass',
        () {
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(
          open: '"',
          close: '"',
          secondaryOpen: "'",
          secondaryClose: "'",
        ),
      );
      expect(
        SmartyPants.formatText('"say \'don\'t\'"', config: config),
        '"say \'don\u2019t\'"',
      );
    });

    test('apostrophes in contractions still become \\u2019', () {
      expect(
        SmartyPants.formatText("don't"),
        'don\u2019t',
      );
    });

    test('single-quote pass does not match across contractions', () {
      // Apostrophes in "can't" and "won't" must stay apostrophes, not open/close quotes.
      expect(
        SmartyPants.formatText("can't and won't"),
        'can\u2019t and won\u2019t',
      );
    });

    test('custom style without secondary marks leaves apostrophes as \\u2019',
        () {
      const config = SmartyPantsConfig(
        customQuoteStyle: QuoteStyle(open: '[', close: ']'),
      );
      expect(
        SmartyPants.formatText("\"don't\"", config: config),
        "[don\u2019t]",
      );
    });
  });

  group('QuoteStyle equality', () {
    test('identical static constants are equal', () {
      expect(QuoteStyle.french, equals(QuoteStyle.french));
    });

    test('new instance with same values equals static constant', () {
      const custom = QuoteStyle(
        open: '\u00AB',
        close: '\u00BB',
        secondaryOpen: '\u2039',
        secondaryClose: '\u203A',
      );
      expect(custom, equals(QuoteStyle.french));
    });

    test('different QuoteStyles are not equal', () {
      expect(QuoteStyle.french, isNot(equals(QuoteStyle.german)));
    });

    test('hashCode is consistent with equality', () {
      const a = QuoteStyle(open: '[', close: ']');
      const b = QuoteStyle(open: '[', close: ']');
      expect(a.hashCode, equals(b.hashCode));
    });

    test('assertion fails when only secondaryOpen is provided', () {
      expect(
        () => QuoteStyle(open: '[', close: ']', secondaryOpen: '{'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('assertion fails when only secondaryClose is provided', () {
      expect(
        () => QuoteStyle(open: '[', close: ']', secondaryClose: '}'),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('SmartyPantsConfig equality', () {
    test('default configs are equal', () {
      const a = SmartyPantsConfig();
      const b = SmartyPantsConfig();
      expect(a, equals(b));
    });

    test('configs with same fields are equal', () {
      const a = SmartyPantsConfig(
        locale: SmartyPantsLocale.fr,
        dashes: false,
        customQuoteStyle: QuoteStyle.french,
      );
      const b = SmartyPantsConfig(
        locale: SmartyPantsLocale.fr,
        dashes: false,
        customQuoteStyle: QuoteStyle.french,
      );
      expect(a, equals(b));
    });

    test('configs with different fields are not equal', () {
      const a = SmartyPantsConfig(dashes: true);
      const b = SmartyPantsConfig(dashes: false);
      expect(a, isNot(equals(b)));
    });

    test('hashCode is consistent with equality', () {
      const a = SmartyPantsConfig(locale: SmartyPantsLocale.ko);
      const b = SmartyPantsConfig(locale: SmartyPantsLocale.ko);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('copyWith result equals manually constructed config', () {
      const original = SmartyPantsConfig(locale: SmartyPantsLocale.fr);
      final copy = original.copyWith(dashes: false);
      const manual = SmartyPantsConfig(
        locale: SmartyPantsLocale.fr,
        dashes: false,
      );
      expect(copy, equals(manual));
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
