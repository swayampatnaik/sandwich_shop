import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    late PricingRepository pricing;

    setUp(() {
      pricing = PricingRepository();
    });

    test('returns 0 for zero quantity', () {
      expect(pricing.totalPrice(0, isFootlong: true), 0.0);
      expect(pricing.totalPrice(0, isFootlong: false), 0.0);
    });

    test('calculates six-inch price correctly', () {
      expect(pricing.totalPrice(2, isFootlong: false), 14.0);
    });

    test('calculates footlong price correctly', () {
      expect(pricing.totalPrice(3, isFootlong: true), 33.0);
    });

    test('works for mixed boundary values', () {
      expect(pricing.totalPrice(1, isFootlong: false), PricingRepository.sixInchPrice);
      expect(pricing.totalPrice(1, isFootlong: true), PricingRepository.footlongPrice);
    });
  });
}