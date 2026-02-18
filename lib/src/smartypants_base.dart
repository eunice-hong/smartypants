import 'tokenizer.dart';

class SmartyPantsConfig {
  final bool smart;

  const SmartyPantsConfig({this.smart = true});
}

class SmartyPants {
  static String formatText(String input, {SmartyPantsConfig? config}) {
    final effectiveConfig = config ?? const SmartyPantsConfig();
    if (!effectiveConfig.smart) {
      return input;
    }

    final tokens = tokenize(input);
    final buffer = StringBuffer();
    final htmlPlaceholders = <String>[];

    // Create a masked string where HTML tokens are replaced by a placeholder
    // We use a character that is unlikely to be in the input and doesn't interfere with regex.
    // U+FFFC (Object Replacement Character) is a good candidate.
    const placeholderChar = '\uFFFC';

    for (final token in tokens) {
      if (token.type == TokenType.html) {
        htmlPlaceholders.add(token.content);
        buffer.write(placeholderChar);
      } else {
        buffer.write(token.content);
      }
    }

    String transformed = _apply_transformations(buffer.toString());

    // Restore HTML tokens
    final resultBuffer = StringBuffer();
    int placeholderIndex = 0;

    for (int i = 0; i < transformed.length; i++) {
      if (transformed[i] == placeholderChar) {
        if (placeholderIndex < htmlPlaceholders.length) {
          resultBuffer.write(htmlPlaceholders[placeholderIndex++]);
        }
      } else {
        resultBuffer.write(transformed[i]);
      }
    }

    return resultBuffer.toString();
  }

  static String _apply_transformations(String input) {
    // Replace straight quotes with smart quotes
    String output = input.replaceAllMapped(
      RegExp(r'"([^"]+)"'),
      (match) => '“${match[1]}”',
    );

    // Replace triple hyphens with em dash
    output = output.replaceAll('---', '—');

    // Replace double hyphens with en dash
    output = output.replaceAll('--', '–');

    // Replace straight apostrophes with smart apostrophes
    output = output.replaceAll("'", '’');

    // Replace multiple spaces with a single space
    output = output.replaceAll(RegExp(r'\s+'), ' ');

    // Replace ellipsis
    output = output.replaceAll('...', '…');

    // Replace mathematical symbols
    output = output
        .replaceAll('>=', '≥')
        .replaceAll('<=', '≤')
        .replaceAll('!=', '≠');

    // Replace arrows
    output = output
        .replaceAll('<->', '↔')
        .replaceAll('->', '→')
        .replaceAll('<-', '←')
        .replaceAll('=>', '⇒');

    return output;
  }
}
