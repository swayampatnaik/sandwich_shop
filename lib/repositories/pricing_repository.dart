class PricingRepository {
  static const double sixInchPrice = 7.0;
  static const double footlongPrice = 11.0;

  PricingRepository();

  double totalPrice(int quantity, {required bool isFootlong}) {
    if (quantity <= 0) return 0.0;
    final unit = isFootlong ? footlongPrice : sixInchPrice;
    return unit * quantity;
  }
}