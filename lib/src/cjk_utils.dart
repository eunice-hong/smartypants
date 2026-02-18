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

/// Converts angle brackets to proper CJK quotation marks.
///
/// Rules:
/// - `<<text>>` → `《text》` (double angle brackets → double angle quotes)
/// - `<text>` → `〈text〉` (single angle brackets → single angle quotes)
///
/// Skips patterns that conflict with other transformations:
/// - HTML tags (`<div>`, `</p>`, `<!DOCTYPE>`, `<?xml?>`)
/// - Arrow patterns (`<->`, `<-`)
/// - Broken HTML tags (`< div>`)
/// - Math operators (`<=`)
String convertCjkAngleBrackets(String input) {
  // Double angle brackets: <<text>> → 《text》
  String output = input.replaceAllMapped(
    RegExp(r'<<([^<>]+?)>>'),
    (match) {
      final content = match[1]!;
      return '《$content》';
    },
  );

  // Single angle brackets: <text> → 〈text〉
  // Exclude content starting with /, !, ? (HTML special tags)
  output = output.replaceAllMapped(
    RegExp(r'<([^<>\/!?][^<>]*?)>'),
    (match) {
      final content = match[1]!;

      // Skip if content looks like an HTML tag name (starts with a letter)
      if (RegExp(r'^[a-zA-Z]').hasMatch(content)) {
        return match[0]!;
      }

      // Skip if content starts with whitespace (broken HTML tags like < div>)
      if (RegExp(r'^\s').hasMatch(content)) {
        return match[0]!;
      }

      // Skip arrow patterns: <->, <-, <=
      if (RegExp(r'^[-=]').hasMatch(content)) {
        return match[0]!;
      }

      return '〈$content〉';
    },
  );

  return output;
}
