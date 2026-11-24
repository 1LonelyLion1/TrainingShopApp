import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart' show LazySingleton;

import '../../../core/database/app_database.dart';
import '../../catalog/domain/product.dart';
import '../domain/cart.dart';
import '../domain/cart_repository.dart';

@LazySingleton(as: CartRepository)
class DriftCartRepository implements CartRepository {
  DriftCartRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Cart> read() async {
    try {
      final query = _db.select(_db.cartItems)
        ..orderBy([(table) => OrderingTerm.asc(table.position)]);
      final rows = await query.get();
      return Cart(rows.map(_toItem).toList(growable: false));
    } on Object catch (error) {
      debugPrint('Failed to read cart: $error');
      return const Cart();
    }
  }

  /// Замена атомарна: при сбое останется предыдущее состояние корзины.
  @override
  Future<void> write(Cart cart) => _db.transaction(() async {
    await _db.delete(_db.cartItems).go();
    await _db.batch((batch) {
      batch.insertAll(_db.cartItems, [
        for (final (index, item) in cart.items.indexed)
          CartItemsCompanion.insert(
            productId: Value(item.product.id),
            title: item.product.title,
            priceCents: item.product.priceCents,
            description: item.product.description,
            category: item.product.category,
            imageUrl: item.product.imageUrl,
            rating: item.product.rating,
            ratingCount: item.product.ratingCount,
            position: index,
            quantity: item.quantity,
          ),
      ]);
    });
  });

  CartItem _toItem(CartItemRow row) => CartItem(
    product: Product(
      id: row.productId,
      title: row.title,
      priceCents: row.priceCents,
      description: row.description,
      category: row.category,
      imageUrl: row.imageUrl,
      rating: row.rating,
      ratingCount: row.ratingCount,
    ),
    quantity: row.quantity.clamp(1, Cart.maxQuantity),
  );
}
