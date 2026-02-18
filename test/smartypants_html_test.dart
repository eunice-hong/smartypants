import 'package:smartypants/smartypants.dart';
import 'package:test/test.dart';

void main() {
  group('SmartyPants Configuration & HTML', () {
    test('should disable smart punctuation when configured', () {
      String input = '"Hello"';
      String expected = '"Hello"';
      expect(
        SmartyPants.formatText(input, config: SmartyPantsConfig(smart: false)),
        expected,
      );
    });

    test('should preserve HTML tags', () {
      String input = '<p>"Hello"</p>';
      String expected = '<p>“Hello”</p>';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should preserve complex HTML tags', () {
      String input = '<a href="http://example.com" title="Test">"Link"</a>';
      String expected = '<a href="http://example.com" title="Test">“Link”</a>';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should handle HTML comments', () {
      String input = '<!-- "Comment" --> "Text"';
      String expected = '<!-- "Comment" --> “Text”';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should handle multiple lines with HTML', () {
      String input = 'Line 1\n<br>\n"Line 2"';
      String expected = 'Line 1 <br> “Line 2”';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should handle nested HTML tags', () {
      String input = '<div><p><span>"Nested"</span></p></div>';
      String expected = '<div><p><span>“Nested”</span></p></div>';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should ignore quotes inside HTML attributes', () {
      String input =
          '<img src="test.png" alt="\"Quoted\" Alt" title=\'Title\'> "Text"';
      String expected =
          '<img src="test.png" alt="\"Quoted\" Alt" title=\'Title\'> “Text”';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should handle text mixed with self-closing tags', () {
      String input = 'Text <br/> "Quote" <hr> Text';
      String expected = 'Text <br/> “Quote” <hr> Text';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should transform text between strictly adjacent tags', () {
      String input = '<span>"A"</span><span>"B"</span>';
      String expected = '<span>“A”</span><span>“B”</span>';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should handle complex mixed content', () {
      String input = '''
<div class="content">
  <h1>"Title"</h1>
  <p>This is a <em>"test"</em> of <strong>complex</strong> HTML.</p>
  <ul>
    <li>"Item 1" -- Description</li>
    <li>"Item 2" --- Description</li>
  </ul>
</div>''';
      String expected =
          '<div class="content"> <h1>“Title”</h1> <p>This is a <em>“test”</em> of <strong>complex</strong> HTML.</p> <ul> <li>“Item 1” – Description</li> <li>“Item 2” — Description</li> </ul> </div>';
      expect(SmartyPants.formatText(input), expected);
    });

    test('should ignore symbols inside HTML attributes', () {
      String input =
          '<img src="test.png" alt="\"Quoted\" -- Alt" title=\'Title ...\'> "Text" --';
      String expected =
          '<img src="test.png" alt="\"Quoted\" -- Alt" title=\'Title ...\'> “Text” –';
      expect(SmartyPants.formatText(input), expected);
    });

    // 1. Script tags
    test('should preserve content inside script tags', () {
      String input =
          '<script>const x = "foo" -- "bar"; if (x <= 10) {}</script>';
      String expected =
          '<script>const x = "foo" -- "bar"; if (x <= 10) {}</script>';
      expect(SmartyPants.formatText(input), expected);
    });

    // 2. Style tags
    test('should preserve content inside style tags', () {
      String input =
          '<style>body { font-family: "Arial" -- sans-serif; }</style>';
      String expected =
          '<style>body { font-family: "Arial" -- sans-serif; }</style>';
      expect(SmartyPants.formatText(input), expected);
    });

    // 3. Pre tags
    test('should preserve content inside pre tags', () {
      String input = '<pre> "Code" -- block ... </pre>';
      String expected = '<pre> "Code" -- block ... </pre>';
      expect(SmartyPants.formatText(input), expected);
    });

    // 4. Code tags
    test('should preserve content inside code tags', () {
      String input = 'Use <code>"foo" -- bar -> baz</code> for code.';
      String expected = 'Use <code>"foo" -- bar -> baz</code> for code.';
      expect(SmartyPants.formatText(input), expected);
    });

    // 5. Kbd tags
    test('should preserve content inside kbd tags', () {
      String input = '<kbd>"Ctrl"</kbd> + <kbd>"C"</kbd> -> Copy';
      String expected = '<kbd>"Ctrl"</kbd> + <kbd>"C"</kbd> → Copy';
      expect(SmartyPants.formatText(input), expected);
    });

    // 6. Math tags (if applicable, ensuring generic tag handling)
    test('should preserve content inside math tags', () {
      String input = '<math>"expression" != 0</math>';
      String expected = '<math>"expression" != 0</math>';
      expect(SmartyPants.formatText(input), expected);
    });

    // 7. Attributes with greater than sign
    test('should handle attributes containing >', () {
      String input = '<div title="a > b"> "Text" </div>';
      String expected = '<div title="a > b"> “Text” </div>';
      expect(SmartyPants.formatText(input), expected);
    });

    // 8. Attributes with newlines
    test('should handle attributes with newlines', () {
      String input = '<div\nclass="test">\n"Content"\n</div>';
      String expectedOutput = '<div\nclass="test"> “Content” </div>';
      expect(SmartyPants.formatText(input), expectedOutput);
    });

    // 9. Uppercase tags
    test('should handle uppercase tags', () {
      String input = '<DIV>"Text"</DIV>';
      String expected = '<DIV>“Text”</DIV>';
      expect(SmartyPants.formatText(input), expected);
    });

    // 10. Malformed/incomplete tags treated as text
    test('should treat broken tags as text', () {
      String input = '< div> "Text"';
      String expected = '< div> “Text”';
      expect(SmartyPants.formatText(input), expected);
    });

    // 11. Deeply nested HTML
    test('should handle deeply nested HTML', () {
      String input =
          '<div><span><ul><li><a href="#">"Link"</a></li></ul></span></div>';
      String expected =
          '<div><span><ul><li><a href="#">“Link”</a></li></ul></span></div>';
      expect(SmartyPants.formatText(input), expected);
    });
  });
}
