import 'package:equatable/equatable.dart';

import '../../catalog/domain/product.dart';

class CartItem extends Equatable {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  int get totalCents => product.priceCents * quantity;

  CartItem withQuantity(int value) =>
      CartItem(product: product, quantity: value);

  @override
  List<Object?> get props => [product, quantity];
}

/// Неизменяемая корзина: вся логика чистая и тестируется без Flutter.
class Cart extends Equatable {
  const Cart([this.items = const []]);

  static const maxQuantity = 99;

  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;

  int get totalCents => items.fold(0, (sum, item) => sum + item.totalCents);

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  CartItem? itemFor(int productId) {
    for (final item in items) {
      if (item.product.id == productId) return item;
    }
    return null;
  }

  bool contains(int productId) => itemFor(productId) != null;

  Cart add(Product product) {
    final existing = itemFor(product.id);
    if (existing == null) {
      return Cart([...items, CartItem(product: product, quantity: 1)]);
    }
    return setQuantity(product.id, existing.quantity + 1);
  }

  Cart remove(int productId) => Cart(
    items.where((item) => item.product.id != productId).toList(growable: false),
  );

  /// Количество ограничено сверху; значение меньше 1 удаляет позицию.
  Cart setQuantity(int productId, int quantity) {
    if (quantity < 1) return remove(productId);
    final capped = quantity > maxQuantity ? maxQuantity : quantity;
    return Cart(
      items
          .map(
            (item) =>
                item.product.id == productId ? item.withQuantity(capped) : item,
          )
          .toList(growable: false),
    );
  }

  @override
  List<Object?> get props => [items];
}
