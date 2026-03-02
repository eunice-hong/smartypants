import 'package:smartypants/smartypants.dart';
import 'package:test/test.dart';

void main() {
  group('Markdown inline code protection', () {
    test('should preserve arrow inside single-backtick span', () {
      expect(SmartyPants.formatText('`a->b`'), '`a->b`');
    });

    test('should preserve math symbols inside single-backtick span', () {
      expect(SmartyPants.formatText('`x != y`'), '`x != y`');
    });

    test('should preserve dashes inside single-backtick span', () {
      expect(SmartyPants.formatText('`a--b`'), '`a--b`');
    });

    test('should preserve quotes inside single-backtick span', () {
      expect(SmartyPants.formatText('`"hello"`'), '`"hello"`');
    });

    test('should preserve ellipsis inside single-backtick span', () {
      expect(SmartyPants.formatText('`a...b`'), '`a...b`');
    });

    test('should preserve arrow inside double-backtick span', () {
      expect(SmartyPants.formatText('``a->b``'), '``a->b``');
    });

    test('should allow single backtick inside double-backtick span', () {
      expect(SmartyPants.formatText('`` ` ``'), '`` ` ``');
    });

    test('should transform text outside inline code but protect inside', () {
      expect(
        SmartyPants.formatText('"text" `code->here` "more"'),
        '\u201Ctext\u201D `code->here` \u201Cmore\u201D',
      );
    });

    test('should protect multiple inline code spans independently', () {
      expect(
        SmartyPants.formatText('`a->b` and `c--d`'),
        '`a->b` and `c--d`',
      );
    });

    test('should transform text between two inline code spans', () {
      expect(
        SmartyPants.formatText('`a->b` -- `c->d`'),
        '`a->b` \u2013 `c->d`',
      );
    });
  });

  group('Markdown fenced code block protection (backtick)', () {
    test('should preserve content inside triple-backtick fence', () {
      const input = '```\na->b\n```';
      expect(SmartyPants.formatText(input), input);
    });

    test('should preserve content inside fence with language identifier', () {
      const input = '```dart\na->b\nx != y\n```';
      expect(SmartyPants.formatText(input), input);
    });

    test('should transform text before and after fence', () {
      expect(
        SmartyPants.formatText(
          '"before"\n```\na->b\n```\n"after"',
          config: const SmartyPantsConfig(whitespaceNormalization: false),
        ),
        '\u201Cbefore\u201D\n```\na->b\n```\n\u201Cafter\u201D',
      );
    });

    test('should handle four-backtick fence closed by four backticks', () {
      const input = '````\na->b\n````';
      expect(SmartyPants.formatText(input), input);
    });
  });

  group('Markdown fenced code block protection (tilde)', () {
    test('should preserve content inside triple-tilde fence', () {
      const input = '~~~\na->b\n~~~';
      expect(SmartyPants.formatText(input), input);
    });

    test('should preserve content inside tilde fence with language identifier',
        () {
      const input = '~~~python\nx != y\na->b\n~~~';
      expect(SmartyPants.formatText(input), input);
    });

    test('should transform text outside tilde fence', () {
      expect(
        SmartyPants.formatText(
          '"before"\n~~~\na->b\n~~~\n"after"',
          config: const SmartyPantsConfig(whitespaceNormalization: false),
        ),
        '\u201Cbefore\u201D\n~~~\na->b\n~~~\n\u201Cafter\u201D',
      );
    });

    test('should handle four-tilde fence closed by four tildes', () {
      const input = '~~~~\na->b\n~~~~';
      expect(SmartyPants.formatText(input), input);
    });
  });

  group('Unclosed region handling', () {
    test('should treat unclosed inline code as literal and apply transforms',
        () {
      // No closing backtick → backtrack, backtick is plain text
      expect(
        SmartyPants.formatText('`unclosed -> end'),
        '`unclosed \u2192 end',
      );
    });

    test('should protect to end of input for unclosed backtick fence', () {
      const input = '```\na->b\nno closing fence';
      // Everything from ``` to end is protected
      expect(SmartyPants.formatText(input), input);
    });

    test('should protect to end of input for unclosed tilde fence', () {
      const input = '~~~\nx != y\nno closing fence';
      expect(SmartyPants.formatText(input), input);
    });
  });

  group('Edge cases', () {
    test('should treat lone backtick as literal text', () {
      // Single backtick with no match → transform applies to surrounding text
      expect(SmartyPants.formatText('a ` b -> c'), 'a ` b \u2192 c');
    });

    test('should treat one or two tildes as literal text', () {
      expect(SmartyPants.formatText('a ~ b -> c'), 'a ~ b \u2192 c');
      expect(SmartyPants.formatText('a ~~ b -> c'), 'a ~~ b \u2192 c');
    });

    test('should handle consecutive independent inline spans', () {
      // Two spans of different sizes that appear back-to-back in text
      expect(
        SmartyPants.formatText('`a->b` ``c--d``'),
        '`a->b` ``c--d``',
      );
    });

    test('should handle empty inline code span', () {
      expect(SmartyPants.formatText('``'), '``');
    });
  });

  group('Mixed HTML and Markdown', () {
    test('should protect both HTML tags and Markdown inline code', () {
      expect(
        SmartyPants.formatText('<b>"text"</b> `a->b`'),
        '<b>\u201Ctext\u201D</b> `a->b`',
      );
    });

    test('should protect HTML code tag and Markdown inline code independently',
        () {
      expect(
        SmartyPants.formatText('<code>a--b</code> `c--d`'),
        '<code>a--b</code> `c--d`',
      );
    });

    test('should transform text between HTML and Markdown regions', () {
      expect(
        SmartyPants.formatText('<em>"hi"</em> `a->b` "there"'),
        '<em>\u201Chi\u201D</em> `a->b` \u201Cthere\u201D',
      );
    });
  });
}
