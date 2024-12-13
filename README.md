# smartypants

A Dart package that implements SmartyPants text formatting. This package helps convert plain text into a more typographically correct format by replacing certain characters and symbols with their "smart" counterparts.

## Features

- Replaces straight quotes with smart quotes.
- Converts double and triple hyphens into en dash and em dash, respectively.
- Replaces straight apostrophes with smart apostrophes.
- Collapses multiple spaces into a single space.
- Converts ellipses into a single ellipsis character.
- Replaces mathematical symbols with their typographically correct versions.
- Converts arrows into their respective symbols.

## Getting started

To use the `smartypants` package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  smartypants: ^0.0.1
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

## Additional information

For more information about the package, how to contribute, or to report issues, please visit the [GitHub repository](https://github.com/eunice-hong/smartypants).

Feel free to reach out if you have any questions or suggestions!

