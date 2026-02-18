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

    for (final token in tokens) {
      if (token.type == TokenType.html) {
        buffer.write(token.content);
      } else {
        buffer.write(_apply_transformations(token.content));
      }
    }

    return buffer.toString();
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
