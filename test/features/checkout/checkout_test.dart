import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/checkout/domain/checkout_validators.dart';
import 'package:horns_and_hooves_shop_app/features/checkout/presentation/checkout_cubit.dart';

import '../../helpers/fakes.dart';

void main() {
  test('email', () {
    expect(CheckoutValidators.email(''), isNotNull);
    expect(CheckoutValidators.email('a@b'), isNotNull);
    expect(CheckoutValidators.email('a..b@mail.ru'), isNotNull);
    expect(CheckoutValidators.email(' user.name+tag@mail.co.uk '), isNull);
  });

  test('телефон', () {
    expect(CheckoutValidators.phone(''), isNotNull);
    expect(CheckoutValidators.phone('123456789'), isNotNull);
    expect(CheckoutValidators.phone('abc1234567890'), isNotNull);
    expect(CheckoutValidators.phone('+7 (999) 123-45-67'), isNull);
  });

  test('адрес и имя не могут состоять из пробелов', () {
    expect(CheckoutValidators.address('   '), isNotNull);
    expect(CheckoutValidators.name('   '), isNotNull);
  });

  test('заказ создаётся один раз и очищает корзину', () async {
    final cart = CartCubit(FakeCartStorage());
    await cart.add(product());
    final checkout = CheckoutCubit(cart);

    await checkout.submit();
    expect(checkout.state.orderNumber, isNull);
    expect(cart.state.isEmpty, isFalse);

    checkout
      ..changed(CheckoutField.name, 'Остап')
      ..changed(CheckoutField.email, 'ostap@example.com')
      ..changed(CheckoutField.phone, '+7 999 123-45-67')
      ..changed(CheckoutField.address, 'Черноморск');
    expect(checkout.state.isValid, isTrue);

    await checkout.submit();
    final number = checkout.state.orderNumber;
    await checkout.submit();

    expect(number, matches(RegExp(r'^HH-\d{8}-[A-Z2-9]{6}$')));
    expect(checkout.state.orderNumber, number);
    expect(cart.state.isEmpty, isTrue);
    await checkout.close();
    await cart.close();
  });
}
