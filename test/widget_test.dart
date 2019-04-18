// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notes_app/main.dart';

void main() {
  testWidgets('Add note', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(Notes());
    await tester.pumpAndSettle();

    // Verify appbar displays anything
    expect(find.text('Notes'), findsOneWidget);
    // Verify notes empty
    expect(find.text('Empty note list'), findsOneWidget);
    // Tap the FAB to create a note
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    // Makes sure keyboard shows up
    await tester.pump(Duration(milliseconds: 400));
    // Type text
    await tester.enterText(find.byType(TextField), 'Lorem ipsum ...');
    // Save
    await tester.tap(find.byIcon(Icons.done));
    // Check note appear
    await tester.pumpAndSettle();
    expect(find.text('Empty note list'), findsNothing);
    expect(find.text('Lorem ipsum ...'), findsOneWidget);
  });
  testWidgets('Remove note', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(Notes());
    await tester.pumpAndSettle();

    // Create note first
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.pump(Duration(milliseconds: 400));
    await tester.enterText(find.byType(TextField), 'Lorem ipsum ...');
    await tester.tap(find.byIcon(Icons.done));
    await tester.pumpAndSettle();

    expect(find.text('Empty note list'), findsNothing);
    expect(find.text('Lorem ipsum ...'), findsOneWidget);

    await tester.drag(find.text('Lorem ipsum ...'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Empty note list'), findsOneWidget);
    expect(find.text('Lorem ipsum ...'), findsNothing);
  });
}
