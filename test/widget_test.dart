import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/app_drawer.dart';

void main() {
  Future<void> openDrawer(WidgetTester tester) async {
    // Ensure AppBar (and its menu button) exist so the drawer can be opened via the tooltip.
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
  }

  testWidgets('drawer shows main menu items', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Test')),
          drawer: const AppDrawer(),
        ),
      ),
    );

    await openDrawer(tester);

    expect(find.text('Order'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('drawer calls onNavigate with a route containing the tapped label',
      (WidgetTester tester) async {
    String? capturedRoute;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Test')),
          drawer: AppDrawer(
            onNavigate: (route) {
              capturedRoute = route;
            },
          ),
        ),
      ),
    );

    await openDrawer(tester);

    // Tap the Profile tile and ensure onNavigate receives a route that includes 'profile'
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(capturedRoute, isNotNull,
        reason: 'onNavigate should be called when a drawer item is tapped');
    expect(capturedRoute!.toLowerCase(), contains('profile'),
        reason: 'Captured route should reference the Profile item');
  });

  testWidgets('drawer performs default navigation when onNavigate is null',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        // Define the route we expect the drawer to navigate to.
        routes: {
          '/profile': (context) => const Scaffold(body: Center(child: Text('Profile Page'))),
        },
        home: Scaffold(
          appBar: AppBar(title: const Text('Test')),
          drawer: const AppDrawer(), // no onNavigate provided
        ),
      ),
    );

    await openDrawer(tester);

    // Tap the Profile tile and expect the '/profile' route content to be shown.
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile Page'), findsOneWidget);
  });
}