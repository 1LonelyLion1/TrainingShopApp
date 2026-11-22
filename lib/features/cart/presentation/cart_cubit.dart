import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../catalog/domain/product.dart';
import '../data/cart_storage.dart';
import '../domain/cart.dart';

class CartCubit extends Cubit<Cart> {
  CartCubit(this._storage, [super.initial = const Cart()]);

  final CartStorage _storage;
  Future<void> _lastWrite = Future.value();

  Future<void> add(Product product) => _update(state.add(product));

  Future<void> remove(int productId) => _update(state.remove(productId));

  Future<void> increment(int productId) {
    final item = state.itemFor(productId);
    if (item == null) return Future.value();
    return _update(state.setQuantity(productId, item.quantity + 1));
  }

  /// Минимум — 1: удаление выполняется только отдельной кнопкой.
  Future<void> decrement(int productId) {
    final item = state.itemFor(productId);
    if (item == null || item.quantity <= 1) return Future.value();
    return _update(state.setQuantity(productId, item.quantity - 1));
  }

  Future<void> clear() => _update(const Cart());

  /// Записи идут строго по очереди, чтобы старая не перетёрла новую.
  Future<void> _update(Cart next) {
    emit(next);
    return _lastWrite = _lastWrite.then((_) async {
      try {
        await _storage.write(next);
      } on Object catch (error) {
        debugPrint('Failed to save cart: $error');
      }
    });
  }
}
