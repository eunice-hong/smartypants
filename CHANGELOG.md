# Changelog

## [0.0.4](https://github.com/eunice-hong/smartypants/compare/0.0.3...0.0.4) (2026-03-02)


### Features

* add benchmark tests for small, large, CJK, and HTML inputs ([dba102f](https://github.com/eunice-hong/smartypants/commit/dba102fd9d5e398124115504e33378babd46e5a8))
* Add CJK support and pass `SmartyPantsConfig` to the example app. ([2101d63](https://github.com/eunice-hong/smartypants/commit/2101d63cbf378df61aee5a7fd2805c90613d7abe))
* Add CJK typography support ([b79bed5](https://github.com/eunice-hong/smartypants/commit/b79bed5cfea7b740f72a510d70b225a7634e333b))
* Add CJK typography support with locale-based transformations ([fc1dc39](https://github.com/eunice-hong/smartypants/commit/fc1dc3932e48807804aaf9d0963450d99fe8f38e))
* add escaping for literal placeholder characters in SmartyPants processing ([a6190f8](https://github.com/eunice-hong/smartypants/commit/a6190f824c5cd13fa200541341c24358281def1d))
* add feature request issue template ([0a7db45](https://github.com/eunice-hong/smartypants/commit/0a7db45c209b8a05b39ce801ba65fd12ff4566d5))
* add granular configuration examples to ExampleCategory ([9f2efaa](https://github.com/eunice-hong/smartypants/commit/9f2efaa934957e495dd237c595f181646bf8f2ce))
* add granular transformation options to SmartyPantsConfig ([43ecbd0](https://github.com/eunice-hong/smartypants/commit/43ecbd07c687953a2703f477fb0e65ee08bc8fc3))
* Add HTML tokenizer and export it in the main library ([263fb33](https://github.com/eunice-hong/smartypants/commit/263fb333968c6ac4665aa8e2372fe71b1fb0a0b9))
* add issue template for documentation ([682c677](https://github.com/eunice-hong/smartypants/commit/682c677957219cb4ad1ba20715f3391fe4764096))
* create example flutter project ([f21a37b](https://github.com/eunice-hong/smartypants/commit/f21a37b69fb17fc081e08a0fe16b86d7431cd038))
* enhance example interaction by passing configuration to SmartyPants transformations ([e695b2b](https://github.com/eunice-hong/smartypants/commit/e695b2bfde025c090309d6fd23d1ee63bf790920))
* enhance playground with live formatting, clipboard support, and improved text handling ([3e651fb](https://github.com/eunice-hong/smartypants/commit/3e651fb65853e4ac9d044d0a0e01a8a9acdf58be))
* Implement CommonMark compatibility and robust HTML tokenization ([9b6f847](https://github.com/eunice-hong/smartypants/commit/9b6f847fb922820b1e008036beb4be91e5e12402))
* Implement marker strategy for CJK angle brackets to prevent HTML tokenization conflicts ([f9cad47](https://github.com/eunice-hong/smartypants/commit/f9cad470d73c71408f539fccb584d924dcb4b75a))
* initial commit ([cfcd34d](https://github.com/eunice-hong/smartypants/commit/cfcd34d2b81fa7dbf22c6e6745ced612d900ad85))
* Introduce configurable SmartyPants options, refactor text processing with HTML tokenization, and update smart quote/dash rules. ([2c2f857](https://github.com/eunice-hong/smartypants/commit/2c2f8579ea6e5ba2fce44c9e9b55ac7f5d3ac385))
* **issue:** add issue template for chore/task ([01bb677](https://github.com/eunice-hong/smartypants/commit/01bb677d1a2ea03fe17f5ba082a64394c9e38b7d))
* **issues:** add bug report issue template ([2524926](https://github.com/eunice-hong/smartypants/commit/252492656ab023ef035ab3da39a2df3e98d66672))
* optimize quote and whitespace handling in SmartyPants transformations ([7666949](https://github.com/eunice-hong/smartypants/commit/7666949e1ed8fd610e23ff43410445548932340d))
* Overhaul Example App UI with Interactive Playground & Categorized Examples ([07eb1e2](https://github.com/eunice-hong/smartypants/commit/07eb1e263e996abfce705de53b28282532355fdc))
* overhaul example app with Playground and Examples tabs ([94ec031](https://github.com/eunice-hong/smartypants/commit/94ec0315575b05c27e085932a428047670b881af))
* preserve punctuation context across HTML tags by using placeholders during transformation. ([b4943c0](https://github.com/eunice-hong/smartypants/commit/b4943c04d38d4c6c7072b52377ed62c1c7b2cbfb))
* Refactor SmartyPants with configurable options, HTML tokenization, and improved quote/dash handling. ([3b6e735](https://github.com/eunice-hong/smartypants/commit/3b6e735c08b12b3d25f4924690d73ad8ee66149e))
* Refactor SmartyPants with configurable options, HTML tokenization, and improved text processing. ([d3684d4](https://github.com/eunice-hong/smartypants/commit/d3684d4d5655895c052dbb5a661d83ac7473a27e))


### Bug Fixes

* `dart analyze` warnings and lint issues ([7d51c51](https://github.com/eunice-hong/smartypants/commit/7d51c517095ae178a8dcd6e4256bbdd65645acfe))
* Adjust indentation for 'Topic' field validations in design discussion issue template. ([472f9b1](https://github.com/eunice-hong/smartypants/commit/472f9b1512b9ce8b33fcb95d73d95e8f07ffb28a))
* Correct cursor positioning in `SmartypantsFormatter` ([42ca002](https://github.com/eunice-hong/smartypants/commit/42ca002a645b6c5cb2e965c34cff6e38ae5b9222))
* handle empty text in `playground_tab` when disabling formatter ([4095326](https://github.com/eunice-hong/smartypants/commit/40953269be965c4f8da9c39930c9276ba56589d3))
* handle empty text in `playground_tab` when disabling formatter ([f9221c0](https://github.com/eunice-hong/smartypants/commit/f9221c0b3b4fcd75538598f1665129db1817e643))
* handle invalid selection offsets in `SmartypantsFormatter` ([476c90b](https://github.com/eunice-hong/smartypants/commit/476c90b357125a65680d91c352555a0ae974ac50))
* improve closing tag matching in tokenizer to allow whitespace ([62dbbd3](https://github.com/eunice-hong/smartypants/commit/62dbbd35446d3b64da095814195f18100b478d49))
* prevent bitshift operators and padded text from being converted to CJK citations ([0c95e02](https://github.com/eunice-hong/smartypants/commit/0c95e0243cf3ec00a43e7c40fe95a0cff9e63636))
* prevent corruption of literal private-use characters during CJK angle bracket conversion ([4ac233a](https://github.com/eunice-hong/smartypants/commit/4ac233a14f2c7a94196d59db83e562a2e85ccc69))
* Prevent incorrect conversion of non-CJK single angle brackets ([509057d](https://github.com/eunice-hong/smartypants/commit/509057deb52dae4a7763ec24465ba0df4f06d2bb))
* prevent transformation of content in unclosed special HTML tags ([101576e](https://github.com/eunice-hong/smartypants/commit/101576e53612466b9d6f222ebddfc2e8afc1bac5))
* trigger rebuild on text change in playground example ([2f716ea](https://github.com/eunice-hong/smartypants/commit/2f716ea93511a10f387d3a72645de5848d7e2945))
* Update tokenizer to correctly handle HTML comments. ([4150ca3](https://github.com/eunice-hong/smartypants/commit/4150ca3c1085f32779885e3d0bd426019b984d62))

## 0.0.3 - 2026-02-18
### Added
- CJK typography support with locale-based transformations.
- `SmartyPantsConfig` for customization.
- HTML tokenizer for improved text processing and tag handling.
- Exported `Tokenizer` class in the main library.
- Preserved punctuation context across HTML tags using placeholders.

### Changed
- Refactored text processing pipeline to support configuration and tokenization.
- Updated Android package name and application ID to `com.eunice_hong.smartypants`.
- Updated iOS bundle identifiers and Linux application ID.

### Fixed
- Prevent incorrect conversion of non-CJK single angle brackets (including bitshift operators).
- Prevent corruption of literal private-use characters.
- Implement marker strategy for CJK angle brackets to prevent HTML tokenization conflicts.
- Improved closing tag matching in tokenizer to allow whitespace.
- Adjusted indentation for 'Topic' field validations in issue templates.

## 0.0.2 - 2024-12-14
### Added
- Initial version.

## 0.0.1 - 2024-12-13
### Added
- Initial version.
