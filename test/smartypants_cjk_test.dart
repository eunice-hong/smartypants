import 'package:smartypants/smartypants.dart';
import 'package:test/test.dart';

void main() {
  group('CJK Ellipsis Normalization', () {
    test('should normalize three ideographic full stops to ellipsis', () {
      expect(
        SmartyPants.formatText('기다려주세요。。。'),
        '기다려주세요…',
      );
    });

    test('should normalize four+ ideographic full stops to ellipsis', () {
      expect(
        SmartyPants.formatText('뭐라고。。。。'),
        '뭐라고…',
      );
    });

    test('should normalize ideographic stops regardless of locale', () {
      const config = SmartyPantsConfig(locale: SmartyPantsLocale.en);
      expect(
        SmartyPants.formatText('기다려주세요。。。', config: config),
        '기다려주세요…',
      );
    });

    test('should normalize multiple ellipsis in a sentence', () {
      expect(
        SmartyPants.formatText('他說。。。然後。。。就走了'),
        '他說…然後…就走了',
      );
    });

    test('should normalize mixed Hiragana/Katakana with ellipsis', () {
      expect(
        SmartyPants.formatText('漢字とひらがな。。。カタカナ。。。'),
        '漢字とひらがな…カタカナ…',
      );
    });

    test('should still convert ASCII ellipsis', () {
      expect(
        SmartyPants.formatText('기다려주세요...'),
        '기다려주세요…',
      );
    });
  });

  group('CJK Angle Bracket Quotation', () {
    test('should convert double angle brackets in CJK text', () {
      expect(
        SmartyPants.formatText('책<<제목>>을'),
        '책《제목》을',
      );
    });

    test('should convert double angle brackets at end of text', () {
      expect(
        SmartyPants.formatText('책<<제목>>'),
        '책《제목》',
      );
    });

    test('should convert double angle brackets with non-CJK content', () {
      expect(
        SmartyPants.formatText('<<Our Ugly Hero>> "Hey!"'),
        '《Our Ugly Hero》 \u201CHey!\u201D',
      );
    });

    test('should convert single angle brackets with CJK content', () {
      expect(
        SmartyPants.formatText('한국어<작품>텍스트'),
        '한국어〈작품〉텍스트',
      );
    });

    test('should NOT convert angle brackets that look like HTML tags', () {
      final result = SmartyPants.formatText('a<b>c');
      expect(result, 'a<b>c');
    });

    test('should convert double brackets for Traditional Chinese', () {
      expect(
        SmartyPants.formatText('讀<<紅樓夢>>了'),
        '讀《紅樓夢》了',
      );
    });

    test('should convert single brackets for Japanese', () {
      expect(
        SmartyPants.formatText('カフェ<メニュー>です'),
        'カフェ〈メニュー〉です',
      );
    });
  });

  group('CJK with Base Transformations', () {
    test('should apply both CJK and base transforms together', () {
      expect(
        SmartyPants.formatText('"Hello" 기다려주세요。。。'),
        '\u201CHello\u201D 기다려주세요…',
      );
    });

    test('should preserve math symbols', () {
      expect(
        SmartyPants.formatText('x >= 10'),
        'x ≥ 10',
      );
    });

    test('should preserve arrow transforms', () {
      expect(
        SmartyPants.formatText('A -> B'),
        'A → B',
      );
    });

    test('should handle em dash in CJK text', () {
      expect(
        SmartyPants.formatText('잠깐---뭐야?'),
        '잠깐—뭐야?',
      );
    });

    test('should handle en dash in CJK text', () {
      expect(
        SmartyPants.formatText('10--20페이지'),
        '10–20페이지',
      );
    });

    test('should handle smart quotes around CJK text', () {
      expect(
        SmartyPants.formatText('"こんにちは"'),
        '\u201Cこんにちは\u201D',
      );
    });

    test('should handle multiple transformation types together', () {
      expect(
        SmartyPants.formatText('"인용" 그리고。。。 10--20페이지'),
        '\u201C인용\u201D 그리고… 10–20페이지',
      );
    });
  });

  group('CJK with HTML', () {
    test('should preserve HTML tags', () {
      expect(
        SmartyPants.formatText('<p>기다려주세요。。。</p>'),
        '<p>기다려주세요…</p>',
      );
    });

    test('should preserve script content', () {
      expect(
        SmartyPants.formatText('<script>const x = "。。。";</script>'),
        '<script>const x = "。。。";</script>',
      );
    });

    test(
        'should NOT convert double angle brackets inside script tags (bug fix)',
        () {
      const input = '<script>if (a << b) { return; }</script>';
      expect(
        SmartyPants.formatText(input),
        '<script>if (a << b) { return; }</script>',
      );
    });

    test(
        'should NOT convert double angle brackets inside HTML attributes (bug fix)',
        () {
      const input = '<div data-val="<<test>>"></div>';
      expect(
        SmartyPants.formatText(input),
        '<div data-val="<<test>>"></div>',
      );
    });

    test(
        'should convert double angle brackets in text even when mixed with HTML definitions',
        () {
      const input = '<<test>>';
      expect(
        SmartyPants.formatText(input),
        '《test》',
      );
    });
  });

  group('SmartyPantsLocale configuration', () {
    test('default locale should be en', () {
      const config = SmartyPantsConfig();
      expect(config.locale, SmartyPantsLocale.en);
    });

    test('smart=false should disable all transforms regardless of locale', () {
      const config =
          SmartyPantsConfig(smart: false, locale: SmartyPantsLocale.ko);
      expect(
        SmartyPants.formatText('기다려주세요。。。', config: config),
        '기다려주세요。。。',
      );
    });
  });

  group('Backward Compatibility', () {
    test('existing en behavior unchanged without config', () {
      expect(
        SmartyPants.formatText('"Hello, World!"'),
        '\u201CHello, World!\u201D',
      );
    });

    test('existing ellipsis behavior unchanged', () {
      expect(
        SmartyPants.formatText('Hello... World!'),
        'Hello… World!',
      );
    });

    test('existing dash behavior unchanged', () {
      expect(SmartyPants.formatText('A--B'), 'A–B');
      expect(SmartyPants.formatText('A---B'), 'A—B');
    });
  });

  group('CJK Character Boundary Detection', () {
    test('Hiragana should trigger single bracket conversion', () {
      expect(
        SmartyPants.formatText('あ<いう>え'),
        'あ〈いう〉え',
      );
    });

    test('Katakana should trigger single bracket conversion', () {
      expect(
        SmartyPants.formatText('ア<イウ>エ'),
        'ア〈イウ〉エ',
      );
    });

    test('CJK Ideographs should trigger single bracket conversion', () {
      expect(
        SmartyPants.formatText('書<名>字'),
        '書〈名〉字',
      );
    });

    test('Hangul should trigger single bracket conversion', () {
      expect(
        SmartyPants.formatText('가<나다>라'),
        '가〈나다〉라',
      );
    });

    test('Fullwidth digits should trigger bracket conversion', () {
      expect(
        SmartyPants.formatText('１<テスト>２'),
        '１〈テスト〉２',
      );
    });
  });
  group('Regression: Literal Character Preservation', () {
    test('should preserve literal U+E001 characters', () {
      // \uE001 is the marker used internally.
      const input = 'Literal \uE001 should stay \uE001';
      final result = SmartyPants.formatText(input);
      expect(result, equals(input), reason: 'U+E001 was corrupted');
    });

    test('should preserve literal U+E002 characters', () {
      // \uE002 is the escape character used internally.
      const input = 'Literal \uE002 should stay \uE002';
      final result = SmartyPants.formatText(input);
      expect(result, equals(input), reason: 'U+E002 was corrupted');
    });

    test('should handle mixed literal markers and real angle brackets', () {
      const input = '<<quote>> and \uE001literal\uE001';
      final expected = '《quote》 and \uE001literal\uE001';
      final result = SmartyPants.formatText(input);
      expect(result, equals(expected));
    });
  });

  group('Regression: Bitshift Operator Preservation', () {
    test('should NOT convert bitshift-like expressions with spaces', () {
      const input = 'a << b >> c';
      final result = SmartyPants.formatText(input);
      expect(result, equals(input),
          reason: 'Bitshift with spaces was incorrectly converted');
    });

    test('should convert valid CJK citation without spaces', () {
      const input = 'Read <<Title>>';
      final result = SmartyPants.formatText(input);
      expect(result, equals('Read 《Title》'));
    });

    test(
        'should convert valid CJK citation with internal spaces but no padding',
        () {
      const input = 'Read <<The Title>>';
      final result = SmartyPants.formatText(input);
      expect(result, equals('Read 《The Title》'));
    });

    test('should NOT convert citation with internal padding', () {
      // If we enforce "no padding", this should NOT convert.
      const input = 'Read << Title >>';
      final result = SmartyPants.formatText(input);
      expect(result, equals(input),
          reason: 'Padding should invalidate conversion');
    });
  });
  group('Regression: Numeric Single Angle Brackets', () {
    test('should NOT convert numeric single angle brackets', () {
      const input = 'Values <10> are small.';
      final result = SmartyPants.formatText(input);
      expect(result, equals(input),
          reason: 'Numeric content <10> was incorrectly converted');
    });

    test('should NOT convert single angle brackets with emoticon-like content',
        () {
      const input = 'I <3 you';
      final result = SmartyPants.formatText(input);
      expect(result, equals(input),
          reason: 'Emoticon <3 was incorrectly converted');
    });

    test('should still convert valid CJK single angle brackets', () {
      const input = 'See <書籍>';
      final result = SmartyPants.formatText(input);
      expect(result, equals('See 〈書籍〉'));
    });

    test('should preserve HTML-tag-like content (ambiguous alphanumeric)', () {
      const input = 'See <Reference>';
      final result = SmartyPants.formatText(input);
      expect(result, equals('See <Reference>'));
    });
  });
  group('Regression: Non-CJK Single Angle Brackets', () {
    test('should NOT convert single angle brackets with non-CJK content', () {
      const input = 'Note <text> should stay';
      final result = SmartyPants.formatText(input);
      expect(result, equals(input),
          reason: 'Non-CJK <text> was incorrectly converted');
    });

    test('should NOT convert single angle brackets with Cyrillic content', () {
      const input = 'Пример <тест>';
      final result = SmartyPants.formatText(input);
      expect(result, equals(input),
          reason: 'Cyrillic <тест> was incorrectly converted');
    });

    test('should NOT convert single angle brackets with Emoji only', () {
      const input = 'Note <🙂>';
      final result = SmartyPants.formatText(input);
      expect(result, equals(input),
          reason: 'Emoji <🙂> was incorrectly converted');
    });

    test('should convert mixed CJK/Non-CJK content (starts with CJK)', () {
      // Starts with CJK to avoid HTML tokenizer interpreting "Book" as tag name
      const input = 'See <書籍 Book>';
      final result = SmartyPants.formatText(input);
      expect(result, equals('See 〈書籍 Book〉'));
    });
  });

  group('CJK per-transformation flags', () {
    // cjkEllipsisNormalization

    test('cjkEllipsisNormalization=false preserves ideographic full stops', () {
      const config = SmartyPantsConfig(cjkEllipsisNormalization: false);
      expect(
        SmartyPants.formatText('기다려주세요。。。', config: config),
        '기다려주세요。。。',
      );
    });

    test('cjkEllipsisNormalization=false does not affect ASCII ellipsis', () {
      const config = SmartyPantsConfig(cjkEllipsisNormalization: false);
      expect(
        SmartyPants.formatText('Hello...', config: config),
        'Hello\u2026',
      );
    });

    test('cjkEllipsisNormalization=false does not affect angle brackets', () {
      const config = SmartyPantsConfig(cjkEllipsisNormalization: false);
      expect(
        SmartyPants.formatText('책<<제목>>', config: config),
        '책《제목》',
      );
    });

    // cjkAngleBrackets

    test('cjkAngleBrackets=false preserves double angle brackets', () {
      const config = SmartyPantsConfig(cjkAngleBrackets: false);
      expect(
        SmartyPants.formatText('책<<제목>>', config: config),
        '책<<제목>>',
      );
    });

    test('cjkAngleBrackets=false preserves single CJK angle brackets', () {
      const config = SmartyPantsConfig(cjkAngleBrackets: false);
      expect(
        SmartyPants.formatText('한국어<작품>텍스트', config: config),
        '한국어<작품>텍스트',
      );
    });

    test('cjkAngleBrackets=false does not affect CJK ellipsis', () {
      const config = SmartyPantsConfig(cjkAngleBrackets: false);
      expect(
        SmartyPants.formatText('기다려주세요。。。', config: config),
        '기다려주세요\u2026',
      );
    });

    // combinations

    test('both CJK flags false disables both CJK transforms', () {
      const config = SmartyPantsConfig(
        cjkEllipsisNormalization: false,
        cjkAngleBrackets: false,
      );
      expect(
        SmartyPants.formatText('책<<제목>> 기다려주세요。。。', config: config),
        '책<<제목>> 기다려주세요。。。',
      );
    });

    test('ellipsis=false and cjkEllipsisNormalization=false preserves all ellipsis forms', () {
      const config = SmartyPantsConfig(
        ellipsis: false,
        cjkEllipsisNormalization: false,
      );
      expect(
        SmartyPants.formatText('Hello... 기다려주세요。。。', config: config),
        'Hello... 기다려주세요。。。',
      );
    });

    test('smart=false overrides CJK flags', () {
      const config = SmartyPantsConfig(
        smart: false,
        cjkEllipsisNormalization: true,
        cjkAngleBrackets: true,
      );
      expect(
        SmartyPants.formatText('기다려주세요。。。', config: config),
        '기다려주세요。。。',
      );
    });

    test('default config still applies both CJK transforms (regression)', () {
      expect(
        SmartyPants.formatText('책<<제목>> 기다려주세요。。。'),
        '책《제목》 기다려주세요\u2026',
      );
    });
  });
}
