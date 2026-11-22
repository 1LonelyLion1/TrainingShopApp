import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart' show lazySingleton;

import '../../../core/network/connectivity_service.dart';
import '../../catalog/data/catalog_repository.dart';
import '../domain/cart.dart';
import '../presentation/cart_cubit.dart';
import 'cart_api.dart';
import 'cart_storage.dart';

/// Синхронизирует локальную корзину с сервером.
///
/// Fake Store API отвечает успехом на PUT, но не сохраняет изменения.
/// Поэтому серверная корзина импортируется один раз, а дальше источником
/// истины остаётся локальная база, изменения из которой отправляются на сервер.
@lazySingleton
class CartSyncService {
  CartSyncService(
    this._api,
    this._storage,
    this._catalog,
    this._cart,
    this._connectivity,
  );

  static const demoCartId = 1;

  final CartApi _api;
  final CartStorage _storage;
  final CatalogRepository _catalog;
  final CartCubit _cart;
  final ConnectivityService _connectivity;

  StreamSubscription<void>? _savedSubscription;
  StreamSubscription<bool>? _onlineSubscription;
  AppLifecycleListener? _lifecycle;
  bool _online = true;
  bool _isRunning = false;
  bool _rerun = false;

  Future<void> start() async {
    if (_savedSubscription != null) return;
    _savedSubscription = _cart.saved.listen((_) => unawaited(sync()));
    _onlineSubscription = _connectivity.onlineChanges.listen(_onOnlineChanged);
    _lifecycle = AppLifecycleListener(onResume: () => unawaited(sync()));
    _online = await _connectivity.isOnline;
    await sync();
  }

  /// Запросы идут по одному; изменения во время запроса вызовут повтор.
  Future<void> sync() async {
    if (_isRunning) {
      _rerun = true;
      return;
    }
    _isRunning = true;
    try {
      do {
        _rerun = false;
        try {
          await _syncOnce();
        } on Object catch (error) {
          // Ревизия остаётся неотправленной и уйдёт при следующей попытке.
          debugPrint('Failed to sync cart: $error');
        }
      } while (_rerun);
    } finally {
      _isRunning = false;
    }
  }

  Future<void> dispose() async {
    await _savedSubscription?.cancel();
    await _onlineSubscription?.cancel();
    _lifecycle?.dispose();
    _savedSubscription = null;
    _onlineSubscription = null;
    _lifecycle = null;
  }

  void _onOnlineChanged(bool online) {
    final restored = online && !_online;
    _online = online;
    if (restored) unawaited(sync());
  }

  Future<void> _syncOnce() async {
    if (!_online) return;

    final snapshot = await _storage.readSyncSnapshot();
    final isUntouched =
        snapshot.syncedRevision == null &&
        snapshot.localRevision == 0 &&
        snapshot.cart.isEmpty;
    if (isUntouched) {
      await _importRemote();
      return;
    }
    if (snapshot.syncedRevision == snapshot.localRevision) return;

    await _api.updateCart(demoCartId, [
      for (final item in snapshot.cart.items)
        CartLine(productId: item.product.id, quantity: item.quantity),
    ]);
    await _storage.markSynced(snapshot.localRevision);
  }

  Future<void> _importRemote() async {
    final lines = await _api.fetchCart(demoCartId);
    final cart = await _toCart(lines);
    if (await _storage.importRemote(cart)) {
      _cart.applyRemote(cart);
    } else {
      // Пока шёл запрос, пользователь изменил корзину: отправляем его версию.
      _rerun = true;
    }
  }

  Future<Cart> _toCart(List<CartLine> lines) async {
    if (lines.isEmpty) return const Cart();
    var products = await _catalog.readCached();
    if (products.isEmpty) products = await _catalog.refresh();
    final byId = {for (final product in products) product.id: product};

    final quantities = <int, int>{};
    for (final line in lines) {
      if (line.quantity < 1 || !byId.containsKey(line.productId)) continue;
      quantities.update(
        line.productId,
        (value) => value + line.quantity,
        ifAbsent: () => line.quantity,
      );
    }
    return Cart([
      for (final MapEntry(key: id, value: quantity) in quantities.entries)
        CartItem(
          product: byId[id]!,
          quantity: quantity.clamp(1, Cart.maxQuantity),
        ),
    ]);
  }
}
