import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group("App", () {
    testWidgets("App loads OrderScreen", (tester) async {
      await tester.pumpWidget(const App());

      expect(find.text("Sandwich Counter"), findsOneWidget);
    });
  });

  group("OrderScreen UI", () {
    testWidgets("Quantity increments and decrements", (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: OrderScreen(maxQuantity: 5),
      ));
      // wait for layout/animations to finish
      await tester.pumpAndSettle();

      // quantity is shown inside a composed label like "1 white footlong..."
      expect(find.textContaining('1 white'), findsOneWidget);

      // find the interactive IconButton widgets (safer than find.byIcon(Icon))
      final addBtn = find.widgetWithIcon(IconButton, Icons.add);
      final removeBtn = find.widgetWithIcon(IconButton, Icons.remove);

      // make sure the buttons are visible before tapping
      await tester.ensureVisible(addBtn);
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      // assert using textContaining to match the composed string
      expect(find.textContaining('2 white'), findsOneWidget);

      // tap remove and confirm it goes back to 1
      await tester.ensureVisible(removeBtn);
      await tester.tap(removeBtn);
      await tester.pumpAndSettle();

      expect(find.textContaining('1 white'), findsOneWidget);
    });

    // testWidgets("Decrease button disabled at quantity = 0", (tester) async {
    //   await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

    //   // Tap "-" until zero
    //   await tester.tap(find.widgetWithIcon(IconButton, Icons.remove));
    //   await tester.pump();

    //   // Check quantity is 0
    //   expect(find.text("0"), findsOneWidget);

    //   // Find the decrease button widget
    //   final IconButton btn =
    //       tester.widget(find.widgetWithIcon(IconButton, Icons.remove));

    //   expect(btn.onPressed, isNull); // disabled
    // });

    testWidgets("Switch toggles sandwich size", (tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      Switch sw = tester.widget(switchFinder);
      expect(sw.value, true); // starts as footlong

      await tester.tap(switchFinder);
      await tester.pump();

      sw = tester.widget(switchFinder);
      expect(sw.value, false);
    });

    testWidgets("Dropdown menus appear", (tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

      // There are 2 dropdowns: Sandwich Type + Bread Type
      expect(find.byType(DropdownMenu<SandwichType>), findsOneWidget);
      expect(find.byType(DropdownMenu<BreadType>), findsOneWidget);
    });
  });

  group("StyledButton", () {
    testWidgets("StyledButton shows icon + label", (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: StyledButton(
          onPressed: () {},
          icon: Icons.add_shopping_cart,
          label: "Add to Cart",
          backgroundColor: Colors.green,
        ),
      ));

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text("Add to Cart"), findsOneWidget);
    });

    testWidgets("Add to Cart button disabled when quantity = 0",
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

      // Reduce quantity to 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      // expect(find.text("0"), findsOneWidget);

      // Fetch StyledButton widget
      final StyledButton button =
          tester.widget(find.byKey(const Key('addToCartButton')));

      expect(button.onPressed, isNull);
    });

    testWidgets("Add to Cart button enabled when quantity > 0",
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

      // Quantity starts at 1
      expect(find.text("1"), findsOneWidget);

      final StyledButton button =
          tester.widget(find.byType(StyledButton)) as StyledButton;

      expect(button.onPressed, isNotNull);
    });
  });
}
