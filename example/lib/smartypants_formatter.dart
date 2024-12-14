import 'package:flutter/services.dart';
import 'package:smartypants/smartypants.dart';

// A custom TextInputFormatter that uses SmartyPants to format the input text
class SmartypantsFormatter extends TextInputFormatter {
  SmartypantsFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String newText = SmartyPants.formatText(newValue.text);

    // Keep the cursor in the same position
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newText.length,
      ),
    );
  }
}
