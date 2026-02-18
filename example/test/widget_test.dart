import 'package:example/main.dart';
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
}
