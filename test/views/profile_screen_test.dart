import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';

void main() {
  group('ProfileScreen', () {
    testWidgets('enters name and location and pops with result', (WidgetTester tester) async {
      final Cart cart = Cart();
      final NavigatorObserver observer = NavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<Cart>.value(
            value: cart,
            child: const ProfileScreen(),
          ),
          navigatorObservers: [observer],
        ),
      );

      // Two TextFields: name and location
      final Finder nameField = find.byType(TextField).at(0);
      final Finder locationField = find.byType(TextField).at(1);

      await tester.enterText(nameField, 'Alice');
      await tester.enterText(locationField, 'Campus');

      // Tap Save Profile
      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      // After saving, the screen should pop (no longer present)
      expect(find.byType(ProfileScreen), findsNothing);
    });
  });
}
