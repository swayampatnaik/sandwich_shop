import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({
    required this.sandwich,
    required this.quantity,
  });

  double lineTotal(PricingRepository pricing) {
    return pricing.totalPrice(quantity, isFootlong: sandwich.isFootlong);
  }

  bool matches(Sandwich other) {
    return sandwich.type == other.type &&
        sandwich.isFootlong == other.isFootlong &&
        sandwich.breadType == other.breadType;
  }
}

class Cart {
  final PricingRepository _pricing;
  final List<CartItem> _items = [];

  Cart({PricingRepository? pricing}) : _pricing = pricing ?? PricingRepository();

  List<CartItem> get items => List.unmodifiable(_items);

  void add(Sandwich sandwich, [int qty = 1]) {
    if (qty <= 0) return;
    final existing = _items.indexWhere((i) => i.matches(sandwich));
    if (existing >= 0) {
      _items[existing].quantity += qty;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: qty));
    }
  }

  /// Remove a specific sandwich (all quantities). Returns true if removed.
  bool remove(Sandwich sandwich) {
    final idx = _items.indexWhere((i) => i.matches(sandwich));
    if (idx >= 0) {
      _items.removeAt(idx);
      return true;
    }
    return false;
  }

  /// Update quantity for the matching sandwich. If qty <= 0 the item is removed.
  /// Returns true when an existing item was updated/removed, false if not found.
  bool updateQuantity(Sandwich sandwich, int qty) {
    final idx = _items.indexWhere((i) => i.matches(sandwich));
    if (idx < 0) return false;
    if (qty <= 0) {
      _items.removeAt(idx);
    } else {
      _items[idx].quantity = qty;
    }
    return true;
  }

  /// Remove item at a given index. Throws RangeError if index invalid.
  void removeAt(int index) => _items.removeAt(index);

  /// Clear cart
  void clear() => _items.clear();

  /// Total price across all items using the PricingRepository
  double totalPrice() {
    return _items.fold(0.0, (sum, item) => sum + item.lineTotal(_pricing));
  }
}