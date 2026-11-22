import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart' show LazySingleton;

import '../../../core/database/app_database.dart';
import '../../catalog/domain/product.dart';
import '../domain/cart.dart';

/// Согласованный снимок корзины и её состояния синхронизации.
class CartSyncSnapshot {
  const CartSyncSnapshot({
    required this.cart,
    required this.localRevision,
    required this.syncedRevision,
  });

  final Cart cart;

  /// Увеличивается при каждом локальном изменении.
  final int localRevision;

  /// Последняя ревизия, принятая сервером; null — синхронизации ещё не было.
  final int? syncedRevision;
}

abstract interface class CartStorage {
  Future<Cart> read();

  /// Сохраняет корзину и отмечает её как требующую отправки на сервер.
  Future<void> write(Cart cart);

  Future<CartSyncSnapshot> readSyncSnapshot();

  Future<void> markSynced(int revision);

  /// Импортирует серверную корзину, только если локальных изменений не было.
  Future<bool> importRemote(Cart cart);
}

@LazySingleton(as: CartStorage)
class DriftCartStorage implements CartStorage {
  DriftCartStorage(this._db);

  static const _localRevisionKey = 'cart.local_revision';
  static const _syncedRevisionKey = 'cart.synced_revision';

  final AppDatabase _db;

  @override
  Future<Cart> read() async {
    try {
      return await _readCart();
    } on Object catch (error) {
      debugPrint('Failed to read cart: $error');
      return const Cart();
    }
  }

  /// Замена атомарна: при сбое останется предыдущее состояние корзины.
  @override
  Future<void> write(Cart cart) => _db.transaction(() async {
    await _replaceItems(cart);
    final revision = await _readInt(_localRevisionKey) ?? 0;
    await _writeInt(_localRevisionKey, revision + 1);
  });

  /// Ошибка чтения пробрасывается, чтобы не отправить на сервер пустую корзину.
  @override
  Future<CartSyncSnapshot> readSyncSnapshot() => _db.transaction(
    () async => CartSyncSnapshot(
      cart: await _readCart(),
      localRevision: await _readInt(_localRevisionKey) ?? 0,
      syncedRevision: await _readInt(_syncedRevisionKey),
    ),
  );

  @override
  Future<void> markSynced(int revision) =>
      _writeInt(_syncedRevisionKey, revision);

  @override
  Future<bool> importRemote(Cart cart) => _db.transaction(() async {
    final local = await _readCart();
    final revision = await _readInt(_localRevisionKey) ?? 0;
    final synced = await _readInt(_syncedRevisionKey);
    if (!local.isEmpty || revision != 0 || synced != null) return false;

    await _replaceItems(cart);
    await _writeInt(_syncedRevisionKey, 0);
    return true;
  });

  Future<Cart> _readCart() async {
    final query = _db.select(_db.cartItems)
      ..orderBy([(table) => OrderingTerm.asc(table.position)]);
    final rows = await query.get();
    return Cart(rows.map(_toItem).toList(growable: false));
  }

  Future<void> _replaceItems(Cart cart) async {
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
  }

  Future<int?> _readInt(String key) async {
    final query = _db.select(_db.appSettings)
      ..where((table) => table.settingKey.equals(key));
    final row = await query.getSingleOrNull();
    return row == null ? null : int.tryParse(row.settingValue);
  }

  Future<void> _writeInt(String key, int value) => _db
      .into(_db.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(settingKey: key, settingValue: '$value'),
      );

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
