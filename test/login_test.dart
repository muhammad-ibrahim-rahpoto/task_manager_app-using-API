import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/main.dart';


void main() {
  testWidgets('Login Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that login screen is displayed initially.
    expect(find.text('LOGIN'), findsOneWidget);

    // Enter username and password.
    await tester.enterText(find.byType(TextField).at(0), 'kminchelle');
    await tester.enterText(find.byType(TextField).at(1), '0lelplR');

    // Tap the login button.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Print the current widget tree for debugging.
    debugDumpApp();

    // Wait for navigation to complete.
    await tester.pumpAndSettle();
 
  });
}