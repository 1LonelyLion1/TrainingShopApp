import 'package:injectable/injectable.dart' show injectable;

import '../../../cart/domain/cart.dart';
import '../order_number.dart';

/// Оформляет заказ и возвращает его номер.
///
/// Fake Store API не принимает заказы, поэтому номер создаётся локально.
/// Отправка заказа на сервер добавится здесь, без изменений в UI.
@injectable
class PlaceOrder {
  const PlaceOrder();

  Future<String> call(Cart cart) async {
    if (cart.isEmpty) {
      throw ArgumentError.value(cart, 'cart', 'Cannot order an empty cart');
    }
    return generateOrderNumber();
  }
}
