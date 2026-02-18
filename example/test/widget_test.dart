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

  testWidgets('Playground tab shows input field and hint',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Playground is the first tab, should be visible by default
    expect(find.text('Input'), findsOneWidget);
    expect(find.text('Result'), findsOneWidget);
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

  testWidgets('Examples tab shows categories', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Switch to Examples tab
    await tester.tap(find.text('Examples'));
    await tester.pumpAndSettle();

    // Verify at least the first category is visible
    expect(find.text('Smart Quotes'), findsOneWidget);
  });
}
