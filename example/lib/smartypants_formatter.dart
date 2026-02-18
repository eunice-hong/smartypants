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
    // Safety check: if selection is invalid (e.g. -1), we can't calculate prefix.
    // We just return the formatted text with the original selection.
    if (newValue.selection.baseOffset < 0 ||
        newValue.selection.baseOffset > newValue.text.length) {
      return newValue.copyWith(text: newText, selection: newValue.selection);
    }

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
