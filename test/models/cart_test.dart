import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('Cart', () {
    late Cart cart;
    late PricingRepository pricing;

    setUp(() {
      pricing = PricingRepository();
      cart = Cart(pricing: pricing);
    });

    test('adds items and calculates total for six-inch sandwiches', () {
      final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );

      cart.add(s, 2);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
      expect(cart.totalPrice(), 2 * PricingRepository.sixInchPrice);
    });

    test('mixes footlong and six-inch and calculates total', () {
      final six = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      final foot = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wheat,
      );

      cart.add(six, 2); // 2 * 7 = 14
      cart.add(foot, 1); // 1 * 11 = 11
      expect(cart.items.length, 2);
      expect(cart.totalPrice(), 14.0 + 11.0);
    });

    test('removes specific item and updates total', () {
      final s1 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final s2 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );

      cart.add(s1, 1); // 11
      cart.add(s2, 2); // 14
      expect(cart.totalPrice(), 25.0);

      final removed = cart.remove(s1);
      expect(removed, isTrue);
      expect(cart.items.length, 1);
      expect(cart.totalPrice(), 14.0);
    });

    test('updateQuantity removes item when set to zero', () {
      final s = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );
      cart.add(s, 3);
      expect(cart.items.first.quantity, 3);
      final updated = cart.updateQuantity(s, 0);
      expect(updated, isTrue);
      expect(cart.items.isEmpty, isTrue);
      expect(cart.totalPrice(), 0.0);
    });
  });
}