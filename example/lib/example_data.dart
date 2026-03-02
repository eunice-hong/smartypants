/// Preset example data for the SmartyPants example app.
library;

import 'package:smartypants/smartypants.dart';

/// A single example item with input text and a short description.
class ExampleItem {
  final String description;
  final String input;
  final SmartyPantsConfig? config;

  const ExampleItem({
    required this.description,
    required this.input,
    this.config,
  });
}

/// A category of examples grouped by transformation type.
class ExampleCategory {
  final String name;
  final String icon;
  final String summary;
  final List<ExampleItem> items;
  final SmartyPantsConfig? config;

  const ExampleCategory({
    required this.name,
    required this.icon,
    required this.summary,
    required this.items,
    this.config,
  });
}

/// All preset example categories.
const List<ExampleCategory> exampleCategories = [
  ExampleCategory(
    name: 'Smart Quotes',
    icon: '❝',
    summary: 'Straight quotes → curly quotes',
    items: [
      ExampleItem(
        description: 'Double quotes',
        input: '"Hello, World!"',
      ),
      ExampleItem(
        description: 'Smart apostrophe',
        input: "It's a beautiful day.",
      ),
      ExampleItem(
        description: 'Nested quotes',
        input: '"She said, \'Hello!\'"',
      ),
    ],
  ),
  ExampleCategory(
    name: 'Dashes',
    icon: '—',
    summary: 'Hyphens → en/em dashes',
    items: [
      ExampleItem(
        description: 'En dash (double hyphen)',
        input: 'Pages 10--20',
      ),
      ExampleItem(
        description: 'Em dash (triple hyphen)',
        input: 'Wait---what happened?',
      ),
      ExampleItem(
        description: 'Mixed dashes',
        input: 'A--B and C---D',
      ),
    ],
  ),
  ExampleCategory(
    name: 'Ellipsis',
    icon: '…',
    summary: 'Three dots → ellipsis character',
    items: [
      ExampleItem(
        description: 'Trailing ellipsis',
        input: 'To be continued...',
      ),
      ExampleItem(
        description: 'Mid-sentence ellipsis',
        input: 'Well... I think so.',
      ),
    ],
  ),
  ExampleCategory(
    name: 'Math Symbols',
    icon: '≥',
    summary: 'ASCII operators → Unicode symbols',
    items: [
      ExampleItem(
        description: 'Greater than or equal',
        input: 'x >= 10',
      ),
      ExampleItem(
        description: 'Less than or equal',
        input: 'y <= 20',
      ),
      ExampleItem(
        description: 'Not equal',
        input: 'a != b',
      ),
      ExampleItem(
        description: 'Combined',
        input: 'x >= 10 and x <= 20 and x != 15',
      ),
    ],
  ),
  ExampleCategory(
    name: 'Arrows',
    icon: '→',
    summary: 'ASCII arrows → Unicode arrows',
    items: [
      ExampleItem(
        description: 'Right arrow',
        input: 'Input -> Output',
      ),
      ExampleItem(
        description: 'Left arrow',
        input: 'Output <- Input',
      ),
      ExampleItem(
        description: 'Bidirectional arrow',
        input: 'A <-> B',
      ),
      ExampleItem(
        description: 'Fat arrow',
        input: 'condition => result',
      ),
    ],
  ),
  ExampleCategory(
    name: 'HTML Support',
    icon: '</>',
    summary: 'HTML tags are preserved during transformation',
    items: [
      ExampleItem(
        description: 'Tags preserved',
        input: '<p>"Hello, World!"</p>',
      ),
      ExampleItem(
        description: 'Nested HTML',
        input: '<div><em>"Nested"</em> content...</div>',
      ),
      ExampleItem(
        description: 'Script tags untouched',
        input: '<script>const x = "foo" -- "bar";</script>',
      ),
      ExampleItem(
        description: 'Mixed HTML & text',
        input:
            '<h1>"Title"</h1>\n<p>"Item 1" -- Description</p>\n<p>"Item 2" --- Description</p>',
      ),
    ],
  ),
  ExampleCategory(
    name: 'Granular Config',
    icon: '⚙',
    summary: 'Per-transformation control with SmartyPantsConfig',
    items: [
      ExampleItem(
        description: 'Quotes only (dashes disabled)',
        input: '"Hello" -- World',
        config: SmartyPantsConfig(dashes: false),
      ),
      ExampleItem(
        description: 'Dashes only (quotes disabled)',
        input: '"Hello" -- World',
        config: SmartyPantsConfig(quotes: false),
      ),
      ExampleItem(
        description: 'No whitespace normalization',
        input: 'Hello   World...',
        config: SmartyPantsConfig(whitespaceNormalization: false),
      ),
      ExampleItem(
        description: 'Arrows disabled',
        input: 'Step 1 -> Step 2 => Done',
        config: SmartyPantsConfig(arrows: false),
      ),
      ExampleItem(
        description: 'Math symbols disabled',
        input: 'x >= 10 and y != 0',
        config: SmartyPantsConfig(mathSymbols: false),
      ),
      ExampleItem(
        description: 'CJK ellipsis disabled (ASCII ellipsis still works)',
        input: 'Hello... 기다려주세요。。。',
        config: SmartyPantsConfig(cjkEllipsisNormalization: false),
      ),
      ExampleItem(
        description: 'CJK angle brackets disabled',
        input: '책<<제목>>을 읽었다',
        config: SmartyPantsConfig(cjkAngleBrackets: false),
      ),
    ],
  ),
  ExampleCategory(
    name: 'CJK Support',
    icon: '한',
    summary: 'Korean & CJK typography transformations',
    config: SmartyPantsConfig(locale: SmartyPantsLocale.ko),
    items: [
      ExampleItem(
        description: 'CJK ellipsis (。。。 → …)',
        input: '기다려주세요。。。',
      ),
      ExampleItem(
        description: 'Double angle brackets (《》)',
        input: '책<<한국의 역사>>를 읽었다',
      ),
      ExampleItem(
        description: 'Em dash in Korean',
        input: '잠깐---뭐야?',
      ),
      ExampleItem(
        description: 'Mixed Korean & English',
        input: '"Hello" 기다려주세요。。。',
      ),
    ],
  ),
];
