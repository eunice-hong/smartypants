# smartypants example

A Flutter app demonstrating the [smartypants](https://pub.dev/packages/smartypants) text formatting
library.

## Features

### Playground Tab

- Type any text and see real-time SmartyPants transformations
- **Live Format** toggle: enables `SmartypantsFormatter` (a `TextInputFormatter`) so text is
  formatted as you type
- Copy the transformed result to clipboard

### Examples Tab

- Browse preset examples grouped by category:
    - **Smart Quotes** — `"Hello"` → `"Hello"`
    - **Dashes** — `--` → `–`, `---` → `—`
    - **Ellipsis** — `...` → `…`
    - **Math Symbols** — `>=` → `≥`, `<=` → `≤`, `!=` → `≠`
    - **Arrows** — `->` → `→`, `<-` → `←`, `<->` → `↔`
    - **HTML Support** — tags preserved, special elements untouched
- Tap any example card to load it in the Playground