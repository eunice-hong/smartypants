import 'package:example/example_data.dart';
import 'package:example/main.dart';
import 'package:example/smartypants_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Renders TabBar with Playground and Examples tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify TabBar is present with both tabs
    expect(find.text('Playground'), findsOneWidget);
    expect(find.text('Examples'), findsOneWidget);
  });

  testWidgets('Playground tab shows input field and labels',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Playground is the first tab, should be visible by default
    expect(find.text('Input'), findsOneWidget);
    expect(find.text('Result'), findsOneWidget);
    expect(find.text('Live Format'), findsOneWidget);
  });

  testWidgets('Playground tab transforms text on input',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find the TextField and enter text
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    await tester.enterText(textField, '"Hello"');
    await tester.pump();

    // Should show the smart-quoted result
    expect(find.text('\u201cHello\u201d'), findsOneWidget);
  });

  testWidgets('Clear button clears input and result',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final textField = find.byType(TextField);
    await tester.enterText(textField, '"Hello"');
    await tester.pump();

    // Clear button should appear
    final clearButton = find.byIcon(Icons.clear_rounded);
    expect(clearButton, findsOneWidget);

    await tester.tap(clearButton);
    await tester.pump();

    // Input and result should be empty
    expect(find.text('\u201cHello\u201d'), findsNothing);
    expect(
      find.text('Type something above to see the result'),
      findsOneWidget,
    );
  });

  testWidgets('Empty state shows placeholder text',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify empty state message
    expect(
      find.text('Type something above to see the result'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.edit_note_rounded), findsWidgets);
  });

  testWidgets('Examples tab shows categories', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Switch to Examples tab
    await tester.tap(find.text('Examples'));
    await tester.pumpAndSettle();

    // Verify at least the first category is visible
    expect(find.text('Smart Quotes'), findsOneWidget);
  });

  testWidgets('Tapping example card navigates to Playground',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Switch to Examples tab
    await tester.tap(find.text('Examples'));
    await tester.pumpAndSettle();

    // Find and tap the first "Try it →" label
    final tryItLabel = find.text('Try it →');
    expect(tryItLabel, findsWidgets);
    await tester.tap(tryItLabel.first);
    await tester.pumpAndSettle();

    // Should be back on Playground tab with formatted text
    expect(find.text('Input'), findsOneWidget);
  });

  test(
      'SmartypantsFormatter calculates cursor correctly when editing before a transformation',
      () {
    final formatter = SmartypantsFormatter();

    // Scenario: User has " --" (unformatted) and types "a" at the beginning.
    // OldValue: " --" (selection at 0)
    // NewValue: "a --" (selection at 1, user just typed 'a')

    // Formatter converts "a --" -> "a –" (en dash).
    // Length diff is 4 - 5 = -1.
    // Buggy logic: cursor 1 + (-1) = 0.
    // Correct logic: Prefix "a" -> formatted "a" (len 1). Cursor 1.

    const oldValue = TextEditingValue(
      text: ' --',
      selection: TextSelection.collapsed(offset: 0),
    );

    const newValue = TextEditingValue(
      text: 'a --',
      selection: TextSelection.collapsed(offset: 1),
    );

    final result = formatter.formatEditUpdate(oldValue, newValue);

    expect(result.text, 'a –');
    expect(result.selection.baseOffset, 1,
        reason: 'Cursor should stay after "a"');
  });

  test('SmartypantsFormatter handles invalid selection offset gracefully', () {
    final formatter = SmartypantsFormatter();

    const oldValue = TextEditingValue(
      text: 'hello',
      selection: TextSelection.collapsed(offset: 5),
    );

    // Simulate a state where selection is invalid (-1)
    const newValue = TextEditingValue(
      text: 'hello',
      selection: TextSelection.collapsed(offset: -1),
    );

    final result = formatter.formatEditUpdate(oldValue, newValue);

    // Should not throw RangeError.
    // If selection is invalid, we probably just return the formatted text
    // with the invalid selection preserved (or maybe normalized to -1).
    expect(result.text, 'hello'); // No format change here
    expect(result.selection.baseOffset, -1);
  });

  // ── CJK Typography Widget Tests ──────────────────────────────────────

  testWidgets('Playground transforms CJK ellipsis input',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final textField = find.byType(TextField);
    await tester.enterText(textField, '기다려주세요。。。');
    await tester.pump();

    // Should normalize ideographic full stops to ellipsis
    expect(find.text('기다려주세요…'), findsOneWidget);
  });

  testWidgets('Playground transforms double angle brackets to CJK quotes',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final textField = find.byType(TextField);
    await tester.enterText(textField, '책<<한국의 역사>>를');
    await tester.pump();

    // Should convert << >> to 《 》
    expect(find.text('책《한국의 역사》를'), findsOneWidget);
  });

  test('exampleCategories includes CJK Support with examples', () {
    final cjkCategory = exampleCategories.firstWhere(
      (c) => c.name == 'CJK Support',
    );
    expect(cjkCategory.items, isNotEmpty);
    expect(
      cjkCategory.items.any((item) => item.input.contains('。。。')),
      isTrue,
      reason: 'CJK category should include an ellipsis example',
    );
  });

  testWidgets('Live Format mode transforms CJK text as user types',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Enable Live Format
    final toggle = find.byType(Switch);
    await tester.tap(toggle);
    await tester.pump();

    // Type CJK text with ideographic stops
    final textField = find.byType(TextField);
    await tester.enterText(textField, '잠깐。。。');
    await tester.pump();

    // The TextField itself should contain the formatted text
    final textFieldWidget = tester.widget<TextField>(textField);
    expect(textFieldWidget.controller?.text, '잠깐…');
  });

  testWidgets('Playground transforms mixed CJK and English input',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final textField = find.byType(TextField);
    await tester.enterText(textField, '"Hello" 기다려주세요。。。');
    await tester.pump();

    // Both smart quotes and CJK ellipsis should be transformed
    expect(find.text('\u201cHello\u201d 기다려주세요…'), findsOneWidget);
  });
}
