/// Core SmartyPants transformation logic.
library smartypants_base;

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

/// Configuration for [SmartyPants.formatText] transformations.
///
/// Controls whether smart typography is applied and which locale-specific
/// rules are used. The default configuration enables all transformations
/// using English rules.
///
/// ```dart
/// // Default: smart English typography
/// const config = SmartyPantsConfig();
///
/// // Disable all transformations (pass-through mode)
/// const passthrough = SmartyPantsConfig(smart: false);
///
/// // Enable Korean CJK transformations
/// const korean = SmartyPantsConfig(locale: SmartyPantsLocale.ko);
/// ```
class SmartyPantsConfig {
  /// Whether smart typography transformations are applied.
  ///
  /// When `false`, [SmartyPants.formatText] returns the input string
  /// unchanged. Defaults to `true`.
  final bool smart;

  /// The locale preset that controls language-specific transformation rules.
  ///
  /// Determines which CJK-specific rules (ellipsis normalization, angle
  /// bracket quotation) are applied in addition to the base transformations.
  /// Defaults to [SmartyPantsLocale.en].
  final SmartyPantsLocale locale;

  /// Creates a [SmartyPantsConfig] with the given options.
  ///
  /// Both parameters are optional. Omitting them produces the default
  /// configuration: smart mode enabled, English locale.
  const SmartyPantsConfig({
    this.smart = true,
    this.locale = SmartyPantsLocale.en,
  });
}

/// Applies SmartyPants-style typography transformations to a string.
///
/// Use [formatText] to convert plain ASCII punctuation into typographically
/// correct Unicode characters. HTML tags and special content regions
/// (`<script>`, `<style>`, `<pre>`, `<code>`, `<kbd>`, `<math>`,
/// `<textarea>`) are preserved and never transformed.
class SmartyPants {
  /// Transforms [input] into typographically correct text.
  ///
  /// Applies the following transformations to plain text content:
  ///
  /// - `"text"` → `"text"` (curly double quotes, U+201C / U+201D)
  /// - `'` → `'` (smart apostrophe, U+2019)
  /// - `---` → `—` (em dash, U+2014)
  /// - `--` → `–` (en dash, U+2013)
  /// - `...` → `…` (ellipsis, U+2026)
  /// - `>=` → `≥`, `<=` → `≤`, `!=` → `≠` (math symbols)
  /// - `->` → `→`, `<-` → `←`, `<->` → `↔`, `=>` → `⇒` (arrows)
  /// - `。。。` → `…` (CJK ideographic full stop → ellipsis)
  /// - `<<text>>` → `《text》` (double angle bracket → CJK title marks)
  /// - `<CJK text>` → `〈CJK text〉` (single angle bracket with CJK content)
  ///
  /// HTML tags are passed through unchanged. Content inside `<script>`,
  /// `<style>`, `<pre>`, `<code>`, `<kbd>`, `<math>`, and `<textarea>` tags
  /// is never transformed.
  ///
  /// Pass a [SmartyPantsConfig] to control which rules apply:
  ///
  /// ```dart
  /// // Default: all transformations enabled
  /// SmartyPants.formatText('"Hello" -- world!');
  /// // → '"Hello" – world!'
  ///
  /// // Disable all transformations
  /// SmartyPants.formatText('"Hello"', config: SmartyPantsConfig(smart: false));
  /// // → '"Hello"'
  ///
  /// // With HTML — tags are preserved
  /// SmartyPants.formatText('<p>"Hello" -- world!</p>');
  /// // → '<p>"Hello" – world!</p>'
  /// ```
  ///
  /// Returns [input] unchanged when [SmartyPantsConfig.smart] is `false`.
  static String formatText(String input, {SmartyPantsConfig? config}) {
    final effectiveConfig = config ?? const SmartyPantsConfig();
    if (!effectiveConfig.smart) {
      return input;
    }

    // Convert angle brackets to CJK quotation marks.
    // We use a marker strategy to protect << sequences from being tokenized
    // as HTML tags or hidden inside HTML tokens.
    //
    // marker: U+E001 (Private Use)
    // escape: U+E002 (Private Use)
    const doubleAngleMarker = '\uE001';
    const markerEscape = '\uE002';

    // 1. Escape existing markerEscape and doubleAngleMarker chars in input.
    //    Must escape markerEscape first!
    final escapedInput = input
        .replaceAll(markerEscape, '$markerEscape$markerEscape')
        .replaceAll(doubleAngleMarker, '$markerEscape$doubleAngleMarker');

    // 2. Replace << with the marker.
    final preprocessed = escapedInput.replaceAll('<<', doubleAngleMarker);

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

    String transformed = _applyTransformations(buffer.toString(),
        effectiveConfig.locale, doubleAngleMarker, markerEscape);

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

    // Restore markers and unescape literals
    final finalBuffer = StringBuffer();
    final resultString = resultBuffer.toString();

    for (int i = 0; i < resultString.length; i++) {
      if (resultString[i] == markerEscape) {
        if (i + 1 < resultString.length) {
          final nextChar = resultString[i + 1];
          // \uE002\uE002 -> \uE002
          // \uE002\uE001 -> \uE001
          if (nextChar == markerEscape || nextChar == doubleAngleMarker) {
            finalBuffer.write(nextChar);
            i++;
          } else {
            // Stray escape char, just write it
            finalBuffer.write(markerEscape);
          }
        } else {
          finalBuffer.write(markerEscape);
        }
      } else if (resultString[i] == doubleAngleMarker) {
        // Unescaped marker -> <<
        finalBuffer.write('<<');
      } else {
        finalBuffer.write(resultString[i]);
      }
    }

    return finalBuffer.toString();
  }

  static String _applyTransformations(String input, SmartyPantsLocale locale,
      String doubleAngleMarker, String markerEscape) {
    String output = input;

    // CJK-style transformations (applied before base transformations)

    // Normalize CJK-style ellipsis (。。。 → …)
    output = normalizeCjkEllipsis(output);

    // Convert angle brackets using the marker
    output = convertCjkAngleBrackets(output,
        doubleAngleMarker: doubleAngleMarker, markerEscape: markerEscape);

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
