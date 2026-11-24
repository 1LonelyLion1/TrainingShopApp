import 'cart.dart';

abstract interface class CartRepository {
  /// Сохранённая корзина; при сбое чтения — пустая.
  Future<Cart> read();

  Future<void> write(Cart cart);
}
