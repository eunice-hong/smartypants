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
    // U+FFFC (Object Replacement Character) for tags.
    const placeholderChar = '\uFFFC';
    // U+E000 (Private Use) as an escape character for literals.
    const escapeChar = '\uE000';

    for (final token in tokens) {
      if (token.type == TokenType.html) {
        htmlPlaceholders.add(token.content);
        buffer.write(placeholderChar);
      } else {
        // Escape literal escapeChar and placeholderChar in text
        // Must escape the escapeChar first!
        String escaped = token.content
            .replaceAll(escapeChar, '$escapeChar$escapeChar')
            .replaceAll(placeholderChar, '$escapeChar$placeholderChar');
        buffer.write(escaped);
      }
    }

    String transformed = _apply_transformations(buffer.toString());

    // Restore HTML tokens
    final resultBuffer = StringBuffer();
    int placeholderIndex = 0;

    for (int i = 0; i < transformed.length; i++) {
      if (transformed[i] == escapeChar) {
        // Next character is literal
        if (i + 1 < transformed.length) {
          resultBuffer.write(transformed[i + 1]);
          i++; // Skip the literal char we just wrote
        }
      } else if (transformed[i] == placeholderChar) {
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
