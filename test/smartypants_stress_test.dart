import 'package:test/test.dart';
import 'package:smartypants/smartypants.dart';

void main() {
  group('Stress tests', () {
    test('10KB input completes within 100ms', () {
      final input = '"Hello" -- World... ' * 500;
      final sw = Stopwatch()..start();
      SmartyPants.formatText(input);
      sw.stop();
      expect(
        sw.elapsedMilliseconds,
        lessThan(100),
        reason: 'Took ${sw.elapsedMilliseconds}ms for ~10KB input',
      );
    });

    test('100KB input completes within 1000ms', () {
      final input = '"Hello" -- World... ' * 5000;
      final sw = Stopwatch()..start();
      SmartyPants.formatText(input);
      sw.stop();
      expect(
        sw.elapsedMilliseconds,
        lessThan(1000),
        reason: 'Took ${sw.elapsedMilliseconds}ms for ~100KB input',
      );
    });

    test('HTML-heavy input (1000 tags) completes within 200ms', () {
      final input = '<p>"Hello" -- World...</p>\n' * 200;
      final sw = Stopwatch()..start();
      SmartyPants.formatText(input);
      sw.stop();
      expect(
        sw.elapsedMilliseconds,
        lessThan(200),
        reason: 'Took ${sw.elapsedMilliseconds}ms for HTML-heavy input',
      );
    });
  });
}
