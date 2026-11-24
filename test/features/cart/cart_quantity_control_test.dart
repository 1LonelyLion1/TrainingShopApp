import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/cart.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/usecases/save_cart.dart';
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_quantity_control.dart';
import 'package:horns_and_hooves_shop_app/l10n/l10n.dart';

import '../../helpers/fakes.dart';

Future<CartCubit> _pump(
  WidgetTester tester, [
  Cart initial = const Cart(),
]) async {
  final cart = CartCubit(SaveCart(FakeCartRepository()), initial);
  addTearDown(cart.close);
  await tester.pumpWidget(
    BlocProvider.value(
      value: cart,
      child: MaterialApp(
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: SizedBox(
            width: 170,
            child: CartQuantityControl(product: product()),
          ),
        ),
      ),
    ),
  );
  return cart;
}

void main() {
  testWidgets('добавляет товар и показывает счётчик', (tester) async {
    final cart = await _pump(tester);

    await tester.tap(find.text('В корзину'));
    await tester.pump();

    expect(cart.state.itemFor(1)?.quantity, 1);
    expect(find.text('В корзину'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('плюс и минус меняют количество', (tester) async {
    final cart = await _pump(tester, const Cart().add(product()));

    await tester.tap(find.byTooltip('Увеличить'));
    await tester.pump();
    expect(cart.state.itemFor(1)?.quantity, 2);

    await tester.tap(find.byTooltip('Уменьшить'));
    await tester.pump();
    expect(cart.state.itemFor(1)?.quantity, 1);
  });

  testWidgets('при количестве 1 минус удаляет товар', (tester) async {
    final cart = await _pump(tester, const Cart().add(product()));
    expect(find.byTooltip('Уменьшить'), findsNothing);

    await tester.tap(find.byTooltip('Удалить'));
    await tester.pump();

    expect(cart.state.isEmpty, isTrue);
    expect(find.text('В корзину'), findsOneWidget);
  });

  testWidgets('на максимуме плюс неактивен', (tester) async {
    await _pump(
      tester,
      const Cart().add(product()).setQuantity(1, Cart.maxQuantity),
    );

    final plus = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.add),
        matching: find.byType(IconButton),
      ),
    );
    expect(plus.onPressed, isNull);
  });
}
