# Changelog

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
