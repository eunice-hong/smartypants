import 'dart:math';
import 'package:test/test.dart';
import 'package:smartypants/smartypants.dart';

// Characters that are used internally as sentinels by the smartypants library.
// U+E000, U+E001, U+E002 are private-use-area markers; U+FFFC is the object
// replacement character used during HTML tag masking.
const _sentinelChars = ['\uE000', '\uE001', '\uE002', '\uFFFC'];

String _randomString(
  Random rng,
  int maxLength, {
  required bool includeSpecial,
}) {
  final length = rng.nextInt(maxLength) + 1;
  final buffer = StringBuffer();
  for (int i = 0; i < length; i++) {
    if (includeSpecial && rng.nextInt(10) == 0) {
      // ~10% chance to insert a sentinel or private-use character
      buffer.write(_sentinelChars[rng.nextInt(_sentinelChars.length)]);
    } else {
      // Printable ASCII range (0x20–0x7E)
      buffer.writeCharCode(rng.nextInt(0x7F - 0x20) + 0x20);
    }
  }
  return buffer.toString();
}

void main() {
  group('Fuzz: formatText never throws', () {
    // Fixed seed for reproducibility across runs.
    final rng = Random(42);

    test('random ASCII input does not throw', () {
      for (int i = 0; i < 10000; i++) {
        final input = _randomString(rng, 100, includeSpecial: false);
        expect(
          () => SmartyPants.formatText(input),
          returnsNormally,
          reason: 'Iteration $i, input: $input',
        );
      }
    });

    test(
        'input with private-use-area chars (U+E000–U+E002, U+FFFC) does not throw',
        () {
      for (int i = 0; i < 5000; i++) {
        final input = _randomString(rng, 50, includeSpecial: true);
        expect(
          () => SmartyPants.formatText(input),
          returnsNormally,
          reason: 'Iteration $i, input: $input',
        );
      }
    });

    test('idempotency: formatText(formatText(x)) == formatText(x)', () {
      for (int i = 0; i < 1000; i++) {
        final input = _randomString(rng, 80, includeSpecial: false);
        final once = SmartyPants.formatText(input);
        final twice = SmartyPants.formatText(once);
        expect(twice, equals(once), reason: 'Input: $input');
      }
    });
  });
}
