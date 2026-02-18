import 'cjk_utils.dart';
import 'tokenizer.dart';

/// Supported locale presets for typography transformations.
///
/// Each locale applies language-specific rules on top of the base
/// SmartyPants transformations.
enum SmartyPantsLocale {
  /// English (default). Standard SmartyPants transformations only.
  en,

  /// Korean. Adds CJK ellipsis normalization and angle bracket quotation.
  ko,

  /// Japanese. Adds CJK ellipsis normalization and angle bracket quotation.
  ja,

  /// Traditional Chinese. Adds CJK ellipsis normalization and angle bracket quotation.
  zhHant,

  /// Simplified Chinese. Adds CJK ellipsis normalization and angle bracket quotation.
  zhHans,
}

class SmartyPantsConfig {
  final bool smart;
  final SmartyPantsLocale locale;

  const SmartyPantsConfig({
    this.smart = true,
    this.locale = SmartyPantsLocale.en,
  });
}

class SmartyPants {
  static String formatText(String input, {SmartyPantsConfig? config}) {
    final effectiveConfig = config ?? const SmartyPantsConfig();
    if (!effectiveConfig.smart) {
      return input;
    }

    // Convert angle brackets to CJK quotation marks.
    // We use a marker strategy to protect << sequences from being tokenized
    // as HTML tags or hidden inside HTML tokens.
    // 1. Replace << with a marker that the tokenizer treats as text.
    const doubleAngleMarker = '\uE001';
    final preprocessed = input.replaceAll('<<', doubleAngleMarker);

    final tokens = tokenize(preprocessed);
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

    String transformed = _applyTransformations(
        buffer.toString(), effectiveConfig.locale, doubleAngleMarker);

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

    // Restore remaining markers back to <<
    return resultBuffer.toString().replaceAll(doubleAngleMarker, '<<');
  }

  static String _applyTransformations(
      String input, SmartyPantsLocale locale, String doubleAngleMarker) {
    String output = input;

    // CJK-style transformations (applied before base transformations)

    // Normalize CJK-style ellipsis (。。。 → …)
    output = normalizeCjkEllipsis(output);

    // Convert angle brackets using the marker
    output =
        convertCjkAngleBrackets(output, doubleAngleMarker: doubleAngleMarker);

    // Base transformations (applied for all locales)

    // Replace straight quotes with smart quotes
    output = output.replaceAllMapped(
      RegExp(r'"([^"]+)"'),
      (match) => '\u201C${match[1]}\u201D',
    );

    // Replace triple hyphens with em dash
    output = output.replaceAll('---', '\u2014');

    // Replace double hyphens with en dash
    output = output.replaceAll('--', '\u2013');

    // Replace straight apostrophes with smart apostrophes
    output = output.replaceAll("'", '\u2019');

    // Replace multiple spaces with a single space
    output = output.replaceAll(RegExp(r'\s+'), ' ');

    // Replace ellipsis
    output = output.replaceAll('...', '\u2026');

    // Replace mathematical symbols
    output = output
        .replaceAll('>=', '\u2265')
        .replaceAll('<=', '\u2264')
        .replaceAll('!=', '\u2260');

    // Replace arrows
    output = output
        .replaceAll('<->', '\u2194')
        .replaceAll('->', '\u2192')
        .replaceAll('<-', '\u2190')
        .replaceAll('=>', '\u21D2');

    return output;
  }
}
