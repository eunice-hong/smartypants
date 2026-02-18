import 'package:flutter/services.dart';
import 'package:smartypants/smartypants.dart';

// A custom TextInputFormatter that uses SmartyPants to format the input text
class SmartypantsFormatter extends TextInputFormatter {
  SmartypantsFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String newText = SmartyPants.formatText(newValue.text);

    // To correctly position the cursor, we format the substring up to the
    // current cursor position (the prefix). The length of this formatted
    // prefix is where the cursor should be in the fully formatted string.
    // This handles cases where edits early in the string shouldn't be affected
    // by length changes (like -- -> –) occurring later in the string.
    final prefix = newValue.text.substring(0, newValue.selection.baseOffset);
    final formattedPrefix = SmartyPants.formatText(prefix);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: formattedPrefix.length.clamp(0, newText.length),
      ),
    );
  }
}
