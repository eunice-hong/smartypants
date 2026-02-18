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
}
