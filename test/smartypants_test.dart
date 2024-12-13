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
}
