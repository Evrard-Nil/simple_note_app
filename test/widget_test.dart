import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notes_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('US testing', () {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });
    testWidgets('US1: Add note', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(Notes());
      await tester.pumpAndSettle();

      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('Empty note list'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.pump(Duration(milliseconds: 400));
      await tester.enterText(find.byType(TextField), 'Lorem ipsum ...');
      await tester.tap(find.byIcon(Icons.done));
      await tester.pumpAndSettle();

      expect(find.text('Empty note list'), findsNothing);
      expect(find.text('Lorem ipsum ...'), findsOneWidget);
    });
    testWidgets('US2: Remove note', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(Notes());
      await tester.pumpAndSettle();

      expect(find.text('Empty note list'), findsNothing);
      expect(find.text('Lorem ipsum ...'), findsOneWidget);

      await tester.drag(find.text('Lorem ipsum ...'), const Offset(500, 0));
      await tester.pumpAndSettle();
      await tester.pump(Duration(milliseconds: 400));

      expect(find.text('Empty note list'), findsOneWidget);
      expect(find.text('Lorem ipsum ...'), findsNothing);
    });
    testWidgets('US3:Edit note', (WidgetTester tester) async {
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

      await tester.tap(find.text('Lorem ipsum ...'));
      await tester.pumpAndSettle();
      await tester.pump(Duration(milliseconds: 400));
      await tester.enterText(find.byType(TextField), 'note edited with this');
      await tester.tap(find.byIcon(Icons.done));
      await tester.pumpAndSettle();

      expect(find.text('Empty note list'), findsNothing);
      expect(find.text('note edited with this'), findsOneWidget);
    });
    testWidgets('US4: backbutton works on note editing page', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(Notes());
      await tester.pumpAndSettle();

      expect(find.text('Empty note list'), findsNothing);
      expect(find.text('note edited with this'), findsOneWidget);

      await tester.tap(find.text('note edited with this'));
      await tester.pumpAndSettle();
      await tester.pump(Duration(milliseconds: 400));
      await tester.enterText(find.byType(TextField), 'Lorem ipsum ...');
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Empty note list'), findsNothing);
      expect(find.text('note edited with this'), findsOneWidget);
      expect(find.text('Lorem ipsum ...'), findsNothing);
    });
    testWidgets('US5: App saves note to SharedPreferences', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(Notes());
      await tester.pumpAndSettle();

      expect(find.text('Empty note list'), findsNothing);
      expect(find.text('note edited with this'), findsOneWidget);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('notes'), <String>['note edited with this']);
    });
    testWidgets('US6: App loads notes from SharedPreferences', (WidgetTester tester) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('notes', <String>['Note1', 'Note2']);
      // Build our app and trigger a frame.
      await tester.pumpWidget(Notes());
      await tester.pumpAndSettle();

      expect(find.text('Empty note list'), findsNothing);
      expect(find.text('Note1'), findsOneWidget);
      expect(find.text('Note2'), findsOneWidget);
    });
  });
}
