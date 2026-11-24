import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/cart.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/usecases/save_cart.dart';
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_cubit.dart';

import '../../helpers/fakes.dart';

void main() {
  group('Cart', () {
    test('добавление нового товара создаёт позицию', () {
      final cart = const Cart().add(product());

      expect(cart.items, hasLength(1));
      expect(cart.itemFor(1)?.quantity, 1);
    });

    test('повторное добавление увеличивает количество', () {
      final cart = const Cart().add(product()).add(product());

      expect(cart.items, hasLength(1));
      expect(cart.itemFor(1)?.quantity, 2);
    });

    test('удаление убирает только указанный товар', () {
      final cart = const Cart().add(product()).add(product(id: 2)).remove(1);

      expect(cart.contains(1), isFalse);
      expect(cart.contains(2), isTrue);
    });

    test('изменение количества пересчитывает сумму', () {
      final cart = const Cart()
          .add(product(priceCents: 1050))
          .add(product(id: 2, priceCents: 299))
          .setQuantity(1, 3);

      expect(cart.totalCents, 3449);
      expect(cart.totalQuantity, 4);
    });

    test('сумма не накапливает ошибку округления', () {
      final cart = const Cart()
          .add(product(priceCents: 10))
          .add(product(id: 2, priceCents: 20));

      expect(cart.totalCents, 30);
    });

    test('количество ограничено максимумом', () {
      final cart = const Cart().add(product()).setQuantity(1, 500);

      expect(cart.itemFor(1)?.quantity, Cart.maxQuantity);
    });

    test('количество меньше единицы удаляет позицию', () {
      final cart = const Cart().add(product()).setQuantity(1, 0);

      expect(cart.isEmpty, isTrue);
    });
  });

  group('CartCubit', () {
    test('сохраняет каждое изменение в порядке вызовов', () async {
      final storage = FakeCartRepository();
      final cubit = CartCubit(SaveCart(storage));

      cubit.add(product());
      cubit.increment(1);
      await cubit.decrement(1);

      expect(storage.history.map((c) => c.totalQuantity), [1, 2, 1]);
      expect(storage.saved, cubit.state);
      await cubit.close();
    });

    test('уменьшение не опускает количество ниже единицы', () async {
      final cubit = CartCubit(SaveCart(FakeCartRepository()));
      await cubit.add(product());

      await cubit.decrement(1);

      expect(cubit.state.itemFor(1)?.quantity, 1);
      await cubit.close();
    });

    test('корзина восстанавливается из хранилища', () async {
      final storage = FakeCartRepository();
      final first = CartCubit(SaveCart(storage));
      await first.add(product(priceCents: 500));
      await first.increment(1);
      await first.close();

      final restored = CartCubit(SaveCart(storage), await storage.read());

      expect(restored.state.totalCents, 1000);
      await restored.close();
    });

    test('очистка сохраняет пустую корзину', () async {
      final storage = FakeCartRepository();
      final cubit = CartCubit(SaveCart(storage));
      await cubit.add(product());

      await cubit.clear();

      expect(cubit.state.isEmpty, isTrue);
      expect(storage.saved.isEmpty, isTrue);
      await cubit.close();
    });
  });
}
