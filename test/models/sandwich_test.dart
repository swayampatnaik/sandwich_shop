import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('returns human readable name for each SandwichType', () {
      final expected = {
        SandwichType.veggieDelight: 'Veggie Delight',
        SandwichType.chickenTeriyaki: 'Chicken Teriyaki',
        SandwichType.tunaMelt: 'Tuna Melt',
        SandwichType.meatballMarinara: 'Meatball Marinara',
      };

      for (final entry in expected.entries) {
        final s = Sandwich(
          type: entry.key,
          isFootlong: true,
          breadType: BreadType.white,
        );
        expect(s.name, entry.value);
      }
    });

    test('image path uses enum name and size suffix', () {
      for (final type in SandwichType.values) {
        final footlong = Sandwich(
          type: type,
          isFootlong: true,
          breadType: BreadType.wheat,
        );
        final sixInch = Sandwich(
          type: type,
          isFootlong: false,
          breadType: BreadType.wholemeal,
        );

        expect(footlong.image, 'assets/images/${type.name}_footlong.png');
        expect(sixInch.image, 'assets/images/${type.name}_six_inch.png');
      }
    });

    test('preserves breadType and size flags', () {
      final s = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      expect(s.isFootlong, isFalse);
      expect(s.breadType, BreadType.wheat);
    });
  });
}