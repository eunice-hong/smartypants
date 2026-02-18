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

    // Adjust cursor position proportionally to account for
    // length changes from formatting (e.g. -- → –)
    final lengthDiff = newText.length - newValue.text.length;
    final cursorOffset = newValue.selection.baseOffset + lengthDiff;
    final clampedOffset = cursorOffset.clamp(0, newText.length);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: clampedOffset),
    );
  }
}
