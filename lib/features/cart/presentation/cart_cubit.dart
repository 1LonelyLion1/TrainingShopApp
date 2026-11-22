import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../catalog/domain/product.dart';
import '../data/cart_storage.dart';
import '../domain/cart.dart';

class CartCubit extends Cubit<Cart> {
  CartCubit(
    this._storage, [
    super.initial = const Cart(),
    this._quantitySaveDelay = const Duration(seconds: 1),
  ]);

  final CartStorage _storage;
  final Duration _quantitySaveDelay;

  Timer? _saveTimer;
  final _saved = StreamController<void>.broadcast();
  Future<void> _lastWrite = Future.value();

  /// Срабатывает после каждой успешной записи корзины в локальную базу.
  Stream<void> get saved => _saved.stream;

  Future<void> add(Product product) => _saveNow(state.add(product));

  Future<void> remove(int productId) => _saveNow(state.remove(productId));

  void increment(int productId) {
    final item = state.itemFor(productId);
    if (item == null) return;
    _saveDebounced(state.setQuantity(productId, item.quantity + 1));
  }

  /// Минимум — 1: удаление выполняется только отдельной кнопкой.
  void decrement(int productId) {
    final item = state.itemFor(productId);
    if (item == null || item.quantity <= 1) return;
    _saveDebounced(state.setQuantity(productId, item.quantity - 1));
  }

  Future<void> clear() => _saveNow(const Cart());

  /// Показывает импортированную корзину, если пользователь её ещё не менял.
  void applyRemote(Cart cart) {
    if (isClosed || !state.isEmpty) return;
    emit(cart);
  }

  /// Сразу сохраняет отложенное изменение, например при уходе в фон.
  Future<void> flush() {
    if (_saveTimer == null) return _lastWrite;
    _saveTimer!.cancel();
    _saveTimer = null;
    return _write(state);
  }

  @override
  Future<void> close() async {
    if (_saveTimer != null) await flush();
    unawaited(_saved.close());
    return super.close();
  }

  /// Экран обновляется сразу, а каждое новое изменение перезапускает таймер.
  void _saveDebounced(Cart next) {
    emit(next);
    _saveTimer?.cancel();
    _saveTimer = Timer(_quantitySaveDelay, () {
      _saveTimer = null;
      unawaited(_write(state));
    });
  }

  /// Записывается корзина целиком, поэтому отложенное изменение не теряется.
  Future<void> _saveNow(Cart next) {
    _saveTimer?.cancel();
    _saveTimer = null;
    emit(next);
    return _write(next);
  }

  /// Записи идут строго по очереди, чтобы старая не перетёрла новую.
  Future<void> _write(Cart cart) => _lastWrite = _lastWrite.then((_) async {
    try {
      await _storage.write(cart);
      if (!_saved.isClosed) _saved.add(null);
    } on Object catch (error) {
      debugPrint('Failed to save cart: $error');
    }
  });
}
