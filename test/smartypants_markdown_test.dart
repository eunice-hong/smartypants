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

    test('closing fence with trailing whitespace is still a valid closer', () {
      // A line of exactly openCount backticks + trailing spaces/tabs closes the
      // block (CommonMark §4.4).
      const input = '```\na->b\n```   ';
      expect(SmartyPants.formatText(input), input);
    });

    // Regression: a line like "```python" starts with >= openCount backticks
    // but has non-whitespace content after them — it must NOT close the fence.
    test(
        'line with fence chars + non-whitespace content does not close the block',
        () {
      // The inner "```python" line has 3 backticks but a non-whitespace tail;
      // it must be treated as code content, not as a closer.
      const input = '```\n```python\na != b\n```';
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

    // Regression: "~~~python" inside a tilde fence must not close the block.
    test('tilde line with non-whitespace tail does not close the fenced block',
        () {
      const input = '~~~\n~~~python\na != b\n~~~';
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

    // Regression: when a double-backtick opener has no matching double-backtick
    // closer, scanMarkdown() backtracks.  The entire run (both backticks) must
    // be consumed atomically as plain text.  If only one backtick were consumed,
    // the second would be retried as a single-backtick opener and could
    // spuriously match the lone closer at the end, masking the content as code.
    test(
        'double-backtick opener with only single-backtick closer applies transforms',
        () {
      // ``a->b` — double-backtick has no closer; single-backtick at end is
      // also unmatched.  Everything is plain text → arrow must be transformed.
      expect(SmartyPants.formatText('``a->b`'), '``a\u2192b`');
    });

    test(
        'single-backtick opener with only double-backtick closer applies transforms',
        () {
      // `a->b`` — single-backtick has no single-backtick closer (the `` at the
      // end has count 2 ≠ 1).  Plain text → arrow must be transformed.
      expect(SmartyPants.formatText('`a->b``'), '`a\u2192b``');
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

  group('Fenced block opener: line-start requirement', () {
    test('triple-backtick mid-line is treated as inline code span', () {
      // ```bar``` mid-line → inline span, not a fenced block
      expect(
        SmartyPants.formatText('use ```bar``` or "quotes"'),
        'use ```bar``` or \u201Cquotes\u201D',
      );
    });

    test('mid-line triple-backtick span protects its content', () {
      expect(
        SmartyPants.formatText('see ```a--b``` here'),
        'see ```a--b``` here',
      );
    });

    test('prose after closed mid-line triple-backtick span is transformed', () {
      expect(
        SmartyPants.formatText('x ```code``` "hi"'),
        'x ```code``` \u201Chi\u201D',
      );
    });

    test('unclosed mid-line triple-backtick backtracks and transforms', () {
      // No matching closer → backtrack, plain text, arrow transformed
      expect(
        SmartyPants.formatText('x ```a->b'),
        'x ```a\u2192b',
      );
    });

    test('triple-backtick after 4-space indent becomes inline span', () {
      // 4 spaces exceeds CommonMark indent limit; not a fenced block opener.
      // Falls through to inline span: content is protected (arrow unchanged),
      // post-span prose is transformed (smart quote applied), and leading
      // whitespace is collapsed by whitespace normalization.
      expect(
        SmartyPants.formatText('    ```\na->b\n```\n"hi"'),
        ' ```\na->b\n``` \u201Chi\u201D',
      );
    });

    test('triple-tilde mid-line backtracks to plain text', () {
      expect(
        SmartyPants.formatText('x ~~~a->b'),
        'x ~~~a\u2192b',
      );
    });

    test('line-start triple-backtick fence still works normally', () {
      expect(
        SmartyPants.formatText('```\na->b\n```\n"hi"'),
        '```\na->b\n```\n\u201Chi\u201D',
      );
    });
  });

  group('Fenced block closer: indented closing fence', () {
    test('1-space indent before closing fence is accepted', () {
      const input = '```\na -> b\n ```\nafter';
      expect(SmartyPants.formatText(input), '```\na -> b\n ```\nafter');
    });

    test('2-space indent before closing fence is accepted', () {
      const input = '```\na -> b\n  ```\nafter';
      expect(SmartyPants.formatText(input), '```\na -> b\n  ```\nafter');
    });

    test('3-space indent before closing fence is accepted', () {
      const input = '```\na -> b\n   ```\nafter';
      expect(SmartyPants.formatText(input), '```\na -> b\n   ```\nafter');
    });

    test('4-space indent before closing fence is not accepted', () {
      // 4-space indent exceeds CommonMark limit; block stays open to end
      const input = '```\na -> b\n    ```';
      expect(SmartyPants.formatText(input), input);
    });

    test('prose after indented closer is transformed', () {
      expect(
        SmartyPants.formatText('```\ncode\n ```\n"hello"'),
        '```\ncode\n ```\n\u201Chello\u201D',
      );
    });
  });

  group('Fenced block closer: CRLF line endings', () {
    test('closing fence with CRLF is accepted (backtick)', () {
      const input = '```\r\na -> b\r\n```\r\nafter';
      expect(SmartyPants.formatText(input), input);
    });

    test('closing fence with CRLF is accepted (tilde)', () {
      const input = '~~~\r\na -> b\r\n~~~\r\nafter';
      expect(SmartyPants.formatText(input), input);
    });

    test('prose after CRLF-terminated closer is transformed', () {
      expect(
        SmartyPants.formatText('```\r\ncode\r\n```\r\n"hello"'),
        '```\r\ncode\r\n```\r\n\u201Chello\u201D',
      );
    });

    test('CRLF closer with trailing spaces is accepted', () {
      expect(
        SmartyPants.formatText('```\r\ncode\r\n```  \r\n"hi"'),
        '```\r\ncode\r\n```  \r\n\u201Chi\u201D',
      );
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

  group('Backtick fence opener: info string validation (P1)', () {
    // CommonMark §4.4: backtick-fence info strings must not contain backticks.
    // If the info string has a backtick, the opener is invalid and must fall
    // through to inline-span matching so prose after the span is transformed.

    test('info string with backtick is not a valid fenced block opener', () {
      // ````code``` "after"` — info string "code```" contains backticks.
      // Falls to inline span (4-backtick opener looking for 4-backtick closer).
      // No 4-backtick closer exists → backtracks → prose is transformed.
      expect(
        SmartyPants.formatText('````code``` "after"'),
        contains('\u201C'), // opening " in "after" must be smart-quoted
      );
    });

    test('info string without backtick opens a valid fenced block', () {
      // ```python\n…\n``` — "python" has no backtick → fenced block protected.
      expect(
        SmartyPants.formatText('```python\na->b\n```\n"hi"'),
        '```python\na->b\n```\n\u201Chi\u201D',
      );
    });

    test('plain fence with no info string still opens a fenced block', () {
      expect(
        SmartyPants.formatText('```\na->b\n```\n"hi"'),
        '```\na->b\n```\n\u201Chi\u201D',
      );
    });
  });

  group('Escaped backtick handling (P2)', () {
    // CommonMark §6.1: a backslash before a backtick escapes it, making it a
    // plain-text literal rather than a code-span delimiter.

    test('backtick preceded by backslash is not a code span opener', () {
      // \`a->b` — the opening backtick is escaped; no code span forms.
      // Arrow must be transformed.
      expect(
        SmartyPants.formatText(r'\`a->b`'),
        contains('\u2192'),
      );
    });

    test('escaped backtick does not swallow arrow in surrounding prose', () {
      // Without the fix, \`a->b` would be mis-parsed as a code span,
      // protecting -> from transformation.
      final result = SmartyPants.formatText(r'\`a->b`');
      expect(result, isNot(contains('->')));
    });

    test('double-backslash before backtick is not an escape (even count)', () {
      // \\`a->b` — two backslashes escape each other, leaving ` as a real
      // opener. Content is protected; arrow must NOT be transformed.
      expect(
        SmartyPants.formatText(r'\\`a->b`'),
        isNot(contains('\u2192')),
      );
    });

    test('triple-backslash before backtick is an escape (odd count)', () {
      // \\\`a->b` — three backslashes: the third is escaped by none, leaving
      // the backtick escaped. Arrow must be transformed.
      expect(
        SmartyPants.formatText(r'\\\`a->b`'),
        contains('\u2192'),
      );
    });
  });
}
