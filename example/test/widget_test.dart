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
}
