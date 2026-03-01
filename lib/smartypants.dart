/// The smartypants library.
///
/// Provides [SmartyPants.formatText] for converting plain text into
/// typographically correct output. Supports smart quotes, en/em dashes,
/// ellipsis, math symbols, arrows, and CJK-specific transformations.
///
/// ```dart
/// final result = SmartyPants.formatText('"Hello" -- world!');
/// // result == '"Hello" – world!'
/// ```
library smartypants;

export 'src/cjk_utils.dart';
export 'src/smartypants_base.dart';
