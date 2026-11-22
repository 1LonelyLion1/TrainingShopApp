import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/cart.dart';
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
    testWidgets('количество сохраняется через секунду после нажатия', (
      tester,
    ) async {
      final storage = FakeCartStorage();
      final cubit = CartCubit(storage);
      await cubit.add(product());
      storage.history.clear();

      cubit.increment(1);
      expect(cubit.state.itemFor(1)?.quantity, 2);

      await tester.pump(const Duration(milliseconds: 999));
      expect(storage.history, isEmpty);

      await tester.pump(const Duration(milliseconds: 1));
      expect(storage.history.single.itemFor(1)?.quantity, 2);
      await cubit.close();
    });

    testWidgets('каждое нажатие перезапускает таймер', (tester) async {
      final storage = FakeCartStorage();
      final cubit = CartCubit(storage);
      await cubit.add(product());
      storage.history.clear();

      cubit.increment(1);
      await tester.pump(const Duration(milliseconds: 900));
      cubit.increment(1);
      await tester.pump(const Duration(milliseconds: 900));
      cubit.decrement(1);
      await tester.pump(const Duration(milliseconds: 900));
      cubit.increment(1);
      await tester.pump(const Duration(milliseconds: 999));
      expect(storage.history, isEmpty);

      await tester.pump(const Duration(milliseconds: 1));
      expect(storage.history.single.itemFor(1)?.quantity, 3);
      await tester.pump(const Duration(seconds: 5));
      expect(storage.history, hasLength(1));
      await cubit.close();
    });

    testWidgets('удаление сохраняется сразу и отменяет таймер', (tester) async {
      final storage = FakeCartStorage();
      final cubit = CartCubit(storage);
      await cubit.add(product());
      await cubit.add(product(id: 2));
      storage.history.clear();

      cubit.increment(1);
      await cubit.remove(2);

      expect(storage.history.single.itemFor(1)?.quantity, 2);
      expect(storage.history.single.contains(2), isFalse);
      await tester.pump(const Duration(seconds: 2));
      expect(storage.history, hasLength(1));
      await cubit.close();
    });

    testWidgets('flush сохраняет отложенное изменение один раз', (
      tester,
    ) async {
      final storage = FakeCartStorage();
      final cubit = CartCubit(storage);
      await cubit.add(product());
      storage.history.clear();

      cubit.increment(1);
      await cubit.flush();

      expect(storage.saved.itemFor(1)?.quantity, 2);
      await tester.pump(const Duration(seconds: 2));
      expect(storage.history, hasLength(1));
      await cubit.close();
    });

    test('уменьшение не опускает количество ниже единицы', () async {
      final cubit = CartCubit(FakeCartStorage());
      await cubit.add(product());

      cubit.decrement(1);

      expect(cubit.state.itemFor(1)?.quantity, 1);
      await cubit.close();
    });

    test('корзина восстанавливается из хранилища', () async {
      final storage = FakeCartStorage();
      final first = CartCubit(storage);
      await first.add(product(priceCents: 500));
      first.increment(1);
      await first.close();

      final restored = CartCubit(storage, await storage.read());

      expect(restored.state.totalCents, 1000);
      await restored.close();
    });

    test('очистка сохраняет пустую корзину', () async {
      final storage = FakeCartStorage();
      final cubit = CartCubit(storage);
      await cubit.add(product());

      await cubit.clear();

      expect(cubit.state.isEmpty, isTrue);
      expect(storage.saved.isEmpty, isTrue);
      await cubit.close();
    });
  });
}
