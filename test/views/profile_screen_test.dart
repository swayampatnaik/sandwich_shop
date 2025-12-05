import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

void main() {
  group('ProfileScreen', () {
    testWidgets('shows SnackBar with entered name on Save', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // There are three TextFormFields: name, email, phone
      final Finder nameField = find.byType(TextFormField).at(0);
      final Finder emailField = find.byType(TextFormField).at(1);
      final Finder phoneField = find.byType(TextFormField).at(2);

      await tester.enterText(nameField, 'Alice');
      await tester.enterText(emailField, 'alice@example.com');
      await tester.enterText(phoneField, '0123456789');

      // Tap the Save button
      await tester.tap(find.text('Save'));

      // Let the SnackBar animation complete
      await tester.pumpAndSettle();

      expect(find.text('Saved profile for Alice'), findsOneWidget);
    });

    testWidgets('shows SnackBar with "User" when name is empty', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // Ensure the name field is empty
      final Finder nameField = find.byType(TextFormField).at(0);
      await tester.enterText(nameField, '');

      // Tap the Save button
      await tester.tap(find.text('Save'));

      // Let the SnackBar animation complete
      await tester.pumpAndSettle();

      expect(find.text('Saved profile for User'), findsOneWidget);
    });
  });
}
