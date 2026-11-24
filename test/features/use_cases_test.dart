import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/core/error/app_failure.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/cart.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/usecases/get_cart.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/usecases/save_cart.dart';
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_repository_impl.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/domain/usecases/get_cached_catalog.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/domain/usecases/refresh_catalog.dart';
import 'package:horns_and_hooves_shop_app/features/checkout/domain/usecases/place_order.dart';
import 'package:horns_and_hooves_shop_app/features/checkout/presentation/checkout_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/settings/domain/usecases/get_saved_language.dart';
import 'package:horns_and_hooves_shop_app/features/settings/domain/usecases/save_language.dart';

import '../helpers/fakes.dart';

void main() {
  group('каталог', () {
    test('GetCachedCatalog читает кеш без обращения к сети', () async {
      final api = FakeCatalogApi(() async => [product(id: 2)]);
      final repository = CatalogRepositoryImpl(
        api: api,
        cache: FakeCatalogCache([product()]),
      );

      expect(await GetCachedCatalog(repository)(), [product()]);
      expect(api.calls, 0);
    });

    test('RefreshCatalog обновляет кеш и пробрасывает ошибки', () async {
      final cache = FakeCatalogCache();
      final api = FakeCatalogApi(() async => [product(id: 2)]);
      final refresh = RefreshCatalog(
        CatalogRepositoryImpl(api: api, cache: cache),
      );

      expect(await refresh(), [product(id: 2)]);
      expect(cache.products, [product(id: 2)]);

      api.handler = () async => throw const TimeoutFailure();
      await expectLater(refresh(), throwsA(isA<TimeoutFailure>()));
    });
  });

  test('GetCart и SaveCart работают через репозиторий', () async {
    final repository = FakeCartRepository();
    final cart = const Cart().add(product());

    await SaveCart(repository)(cart);

    expect(await GetCart(repository)(), cart);
  });

  test('GetSavedLanguage и SaveLanguage работают через репозиторий', () async {
    final repository = FakeLocaleRepository();

    await SaveLanguage(repository)('en');
    expect(await GetSavedLanguage(repository)(), 'en');

    await SaveLanguage(repository)(null);
    expect(await GetSavedLanguage(repository)(), isNull);
  });

  group('PlaceOrder', () {
    test('возвращает номер заказа', () async {
      final number = await const PlaceOrder()(const Cart().add(product()));

      expect(number, matches(RegExp(r'^HH-\d{8}-[A-Z2-9]{6}$')));
    });

    test('не оформляет пустую корзину', () async {
      await expectLater(const PlaceOrder()(const Cart()), throwsArgumentError);
    });

    test('двойное нажатие создаёт один заказ', () async {
      final orders = _CountingPlaceOrder();
      final cart = CartCubit(SaveCart(FakeCartRepository()));
      await cart.add(product());
      final checkout = CheckoutCubit(cart, orders)
        ..changed(CheckoutField.name, 'Остап')
        ..changed(CheckoutField.email, 'ostap@example.com')
        ..changed(CheckoutField.phone, '+7 999 123-45-67')
        ..changed(CheckoutField.address, 'Черноморск');

      await Future.wait([checkout.submit(), checkout.submit()]);

      expect(orders.calls, 1);
      expect(checkout.state.orderNumber, isNotNull);
      await checkout.close();
      await cart.close();
    });
  });
}

class _CountingPlaceOrder extends PlaceOrder {
  int calls = 0;

  @override
  Future<String> call(Cart cart) {
    calls++;
    return super.call(cart);
  }
}
