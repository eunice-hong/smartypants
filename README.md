# smartypants

![Pub Version](https://img.shields.io/pub/v/smartypants) ![GitHub License](https://img.shields.io/github/license/eunice-hong/smartypants)

A Dart package that implements SmartyPants text formatting. This package helps convert plain text into a more typographically correct format by replacing certain characters and symbols with their "smart" counterparts.

## Features

- Replaces straight quotes with smart quotes.
- Converts double and triple hyphens into en dash and em dash, respectively.
- Replaces straight apostrophes with smart apostrophes.
- Collapses multiple spaces into a single space.
- Converts ellipses into a single ellipsis character.
- Replaces mathematical symbols with their typographically correct versions.
- Converts arrows into their respective symbols.
- Supports CJK typography: normalizes CJK ellipsis (。。。 → …) and converts angle bracket citations (<<title>> → 《title》, <CJK text> → 〈CJK text〉) for Korean, Japanese, and Chinese text.
- HTML-aware: preserves all HTML tags and never transforms content inside `<script>`, `<style>`, `<pre>`, `<code>`, `<kbd>`, `<math>`, and `<textarea>` elements.

## Getting started

To use the `smartypants` package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  smartypants: latest_version
```

Then, import the package in your Dart code:

```dart
import 'package:smartypants/smartypants.dart';
```

## Usage

Here’s a simple example of how to use the `SmartyPants` class to format text:

```dart
void main() {
  String input = '"Hello" -- world!';
  String output = SmartyPants.formatText(input);
  print(output); // Prints: “Hello” – world!
}
```

For more complex examples, check the `/example` folder.

## Configuration

By default, all transformations are enabled and the English locale is used. Use `SmartyPantsConfig` to customize behavior:

```dart
// Disable all transformations (pass-through mode)
final output = SmartyPants.formatText(input, config: SmartyPantsConfig(smart: false));

// Enable Korean locale
final output = SmartyPants.formatText(input, config: SmartyPantsConfig(locale: SmartyPantsLocale.ko));
```

### Supported locales

| `SmartyPantsLocale` | Language | CJK ellipsis | Angle bracket citations |
|---|---|---|---|
| `en` | English (default) | Yes | Yes |
| `ko` | Korean | Yes | Yes |
| `ja` | Japanese | Yes | Yes |
| `zhHant` | Traditional Chinese | Yes | Yes |
| `zhHans` | Simplified Chinese | Yes | Yes |

> **Note:** CJK ellipsis normalization (。。。 → …) and angle bracket citation conversion apply regardless of locale when `smart: true`.

## Transformation Reference

| Input | Output | Unicode |
|---|---|---|
| `"text"` | "text" | U+201C / U+201D |
| `'` (apostrophe) | ' | U+2019 |
| `---` | — | U+2014 em dash |
| `--` | – | U+2013 en dash |
| `...` | … | U+2026 |
| `>=` | ≥ | U+2265 |
| `<=` | ≤ | U+2264 |
| `!=` | ≠ | U+2260 |
| `->` | → | U+2192 |
| `<-` | ← | U+2190 |
| `<->` | ↔ | U+2194 |
| `=>` | ⇒ | U+21D2 |
| `。。。` (3+ ideographic stops) | … | U+2026 |
| `<<text>>` | 《text》 | U+300A / U+300B |
| `<CJK text>` | 〈CJK text〉 | U+3008 / U+3009 |

## Additional information

For more information about the package, how to contribute, or to report issues, please visit the [GitHub repository](https://github.com/eunice-hong/smartypants).

Feel free to reach out if you have any questions or suggestions!

