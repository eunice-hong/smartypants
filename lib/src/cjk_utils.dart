/// Utility functions for CJK (Chinese, Japanese, Korean) character detection
/// and typography transformations.

/// Returns `true` if [codeUnit] falls within a CJK character range.
///
/// Covers:
/// - CJK Unified Ideographs (U+4E00–U+9FFF)
/// - CJK Unified Ideographs Extension A (U+3400–U+4DBF)
/// - CJK Compatibility Ideographs (U+F900–U+FAFF)
/// - Hangul Syllables (U+AC00–U+D7AF)
/// - Hangul Jamo (U+1100–U+11FF)
/// - Hangul Compatibility Jamo (U+3130–U+318F)
/// - Hiragana (U+3040–U+309F)
/// - Katakana (U+30A0–U+30FF)
/// - Katakana Phonetic Extensions (U+31F0–U+31FF)
/// - Bopomofo (U+3100–U+312F)
bool isCjkCharacter(int codeUnit) {
  return (codeUnit >= 0x4E00 && codeUnit <= 0x9FFF) || // CJK Unified Ideographs
      (codeUnit >= 0x3400 && codeUnit <= 0x4DBF) || // CJK Extension A
      (codeUnit >= 0xF900 && codeUnit <= 0xFAFF) || // CJK Compatibility
      (codeUnit >= 0xAC00 && codeUnit <= 0xD7AF) || // Hangul Syllables
      (codeUnit >= 0x1100 && codeUnit <= 0x11FF) || // Hangul Jamo
      (codeUnit >= 0x3130 && codeUnit <= 0x318F) || // Hangul Compat Jamo
      (codeUnit >= 0x3040 && codeUnit <= 0x309F) || // Hiragana
      (codeUnit >= 0x30A0 && codeUnit <= 0x30FF) || // Katakana
      (codeUnit >= 0x31F0 && codeUnit <= 0x31FF) || // Katakana Extensions
      (codeUnit >= 0x3100 && codeUnit <= 0x312F); // Bopomofo
}

/// Returns `true` if [codeUnit] is a CJK punctuation character.
///
/// Covers:
/// - CJK Symbols and Punctuation (U+3000–U+303F)
/// - Fullwidth Forms (U+FF00–U+FFEF)
/// - Halfwidth and Fullwidth Forms punctuation subset
bool isCjkPunctuation(int codeUnit) {
  return (codeUnit >= 0x3000 && codeUnit <= 0x303F) || // CJK Symbols & Punct
      (codeUnit >= 0xFF01 && codeUnit <= 0xFF60) || // Fullwidth ASCII variants
      (codeUnit >= 0xFE30 && codeUnit <= 0xFE4F); // CJK Compatibility Forms
}

/// Normalizes CJK-style ellipsis patterns to the Unicode ellipsis character.
///
/// Converts:
/// - `。。。` (three ideographic full stops) → `…`
/// - The standard `...` → `…` conversion is handled by the base transformer.
String normalizeCjkEllipsis(String input) {
  // Replace three or more consecutive ideographic full stops (。) with ellipsis
  return input.replaceAll(RegExp('。{3,}'), '…');
}

/// Converts double and single angle brackets to CJK quotation marks.
///
/// Converts double and single angle brackets to CJK quotation marks.
///
/// If [doubleAngleMarker] is provided, it is used in the regex instead of `<<`.
/// [markerEscape] is used to identify escaped markers that should be ignored.
String convertCjkAngleBrackets(String input,
    {String doubleAngleMarker = '<<', String? markerEscape}) {
  // 1. Double angle brackets: <<text>> -> 《text》

  if (markerEscape != null) {
    // Complex case: matching with escape handling
    // We look for: (escapes)(marker)(content)(marker|>>)
    // Note: The ending part is tricky because we replaced start matching <<
    // but the end >> might still be >> or potentially tokenized differently?
    // Actually the input still has >> as text.

    // Pattern:
    // Group 1: Optional preceding escapes (\uE002*)
    // Group 2: The marker (\uE001)
    // Group 3: Content
    // Followed by >>
    final pattern = RegExp(
      '(${RegExp.escape(markerEscape)}*)(${RegExp.escape(doubleAngleMarker)})([^<>]+?)>>',
    );

    String output = input.replaceAllMapped(pattern, (match) {
      final escapes = match[1]!;
      final marker = match[2]!;
      final content = match[3]!;

      // If odd number of escapes, the marker is literal (escaped)
      // e.g. \uE002\uE001 -> literal \uE001
      if (escapes.length % 2 != 0) {
        return match[0]!;
      }

      // Even number of escapes -> effective marker
      // e.g. \uE002\uE002\uE001 -> literal \uE002 + marker -> convert
      // We must preserve the escapes for the restoration phase

      return '$escapes《$content》';
    });

    // Continue with single bracket conversion...
    // (Rest of the function is identical to below, but we need to return output)
    return _convertSingleAngleBrackets(output);
  } else {
    // Simple case: no escape handling needed (or standard <<)
    final doublePattern = RegExp(
      '${RegExp.escape(doubleAngleMarker)}([^<>]+?)>>',
    );

    String output = input.replaceAllMapped(doublePattern, (match) {
      final content = match[1]!;
      return '《$content》';
    });

    return _convertSingleAngleBrackets(output);
  }
}

String _convertSingleAngleBrackets(String input) {
  return input.replaceAllMapped(
    RegExp(r'<([^<>\/!?][^<>]*?)>'),
    (match) {
      final content = match[1]!;

      // Filter out common false positives
      if (_shouldSkipAngleBracket(content)) {
        return match[0]!;
      }

      return '〈$content〉';
    },
  );
}

bool _shouldSkipAngleBracket(String content) {
  // Skip if content looks like an HTML tag name (starts with a letter)
  if (RegExp(r'^[a-zA-Z]').hasMatch(content)) {
    return true;
  }

  // Skip if content starts with whitespace (broken HTML tags like < div>)
  if (RegExp(r'^\s').hasMatch(content)) {
    return true;
  }

  // Skip arrow patterns: <->, <-, <=
  if (RegExp(r'^[-=]').hasMatch(content)) {
    return true;
  }

  return false;
}
