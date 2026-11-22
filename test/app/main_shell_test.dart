import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/app/app.dart';
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_screen.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_repository.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/catalog_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/catalog_screen.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/filter_sheet.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/product_details_screen.dart';
import 'package:horns_and_hooves_shop_app/features/settings/presentation/locale_cubit.dart';

import '../helpers/fakes.dart';

Future<CartCubit> _pumpApp(WidgetTester tester) async {
  final catalog = CatalogCubit(
    repository: CatalogRepository(
      api: FakeCatalogApi(() async => [product()]),
      cache: FakeCatalogCache(),
    ),
    connectivity: FakeConnectivity(),
  );
  final cart = CartCubit(FakeCartStorage());
  addTearDown(catalog.close);
  final locale = LocaleCubit(FakeLocaleStorage('ru'), const Locale('ru'));
  addTearDown(cart.close);
  addTearDown(locale.close);

  await tester.pumpWidget(
    ShopApp(catalog: catalog, cart: cart, locale: locale),
  );
  await catalog.start();
  await tester.pumpAndSettle();
  return cart;
}

Finder _tab(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

int _selectedTab(WidgetTester tester) =>
    tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

void main() {
  testWidgets('вкладки переключают каталог и корзину', (tester) async {
    await _pumpApp(tester);
    expect(_selectedTab(tester), 0);
    expect(find.text('Товар 1'), findsOneWidget);

    await tester.tap(_tab('Корзина'));
    await tester.pumpAndSettle();

    expect(_selectedTab(tester), 1);
    expect(find.text('Корзина пуста'), findsOneWidget);

    await tester.tap(find.text('Перейти в каталог'));
    await tester.pumpAndSettle();

    expect(_selectedTab(tester), 0);
  });

  testWidgets('значок показывает количество товаров', (tester) async {
    final cart = await _pumpApp(tester);

    await cart.add(product());
    await cart.increment(1);
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(NavigationBar), matching: find.text('2')),
      findsOneWidget,
    );
  });

  testWidgets('нижний отступ панели ограничен', (tester) async {
    tester.view.padding = FakeViewPadding(
      bottom: 34 * tester.view.devicePixelRatio,
    );
    addTearDown(tester.view.resetPadding);

    await _pumpApp(tester);

    expect(tester.getSize(find.byType(NavigationBar)).height, 80 + 12);
  });

  testWidgets('«Назад» с корзины возвращает в каталог', (tester) async {
    await _pumpApp(tester);
    await tester.tap(_tab('Корзина'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(_selectedTab(tester), 0);
  });

  testWidgets('карточка открывается с панелью и ведёт в корзину', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Товар 1'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailsScreen), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(_selectedTab(tester), 0);

    await tester.tap(find.text('В корзину'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('В корзину'));
    await tester.pumpAndSettle();

    expect(_selectedTab(tester), 1);
    expect(find.text('Итого'), findsOneWidget);
  });

  testWidgets('«Назад» с товара из каталога возвращает в каталог', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.text('Товар 1'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailsScreen), findsNothing);
    expect(find.byType(CatalogScreen), findsOneWidget);
    expect(_selectedTab(tester), 0);
  });

  testWidgets('тап по позиции корзины открывает товар, «Назад» — корзину', (
    tester,
  ) async {
    final cart = await _pumpApp(tester);
    await cart.add(product());
    await tester.tap(_tab('Корзина'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(CartScreen),
        matching: find.text('Товар 1'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailsScreen), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(_selectedTab(tester), 1);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailsScreen), findsNothing);
    expect(find.text('Итого'), findsOneWidget);
    expect(_selectedTab(tester), 1);
  });

  testWidgets('кнопки количества в корзине не открывают товар', (tester) async {
    final cart = await _pumpApp(tester);
    await cart.add(product());
    await tester.tap(_tab('Корзина'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Увеличить'));
    await tester.pumpAndSettle();

    expect(cart.state.itemFor(1)?.quantity, 2);
    expect(find.byType(ProductDetailsScreen), findsNothing);
  });

  testWidgets('с экрана товара можно переключить вкладку', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.text('Товар 1'));
    await tester.pumpAndSettle();

    await tester.tap(_tab('Корзина'));
    await tester.pumpAndSettle();
    expect(_selectedTab(tester), 1);
    expect(find.text('Корзина пуста'), findsOneWidget);

    await tester.tap(_tab('Каталог'));
    await tester.pumpAndSettle();
    expect(_selectedTab(tester), 0);
    expect(find.byType(ProductDetailsScreen), findsOneWidget);

    await tester.tap(_tab('Каталог'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailsScreen), findsNothing);
  });

  testWidgets('из каталога товар добавляется и удаляется без перехода', (
    tester,
  ) async {
    final cart = await _pumpApp(tester);

    await tester.tap(find.text('В корзину'));
    await tester.pumpAndSettle();
    expect(cart.state.itemFor(1)?.quantity, 1);
    expect(find.byType(ProductDetailsScreen), findsNothing);

    await tester.tap(find.byTooltip('Удалить'));
    await tester.pumpAndSettle();
    expect(cart.state.isEmpty, isTrue);
    expect(find.byType(ProductDetailsScreen), findsNothing);
  });

  testWidgets('на экране товара количество уменьшается и товар удаляется', (
    tester,
  ) async {
    final cart = await _pumpApp(tester);
    await tester.tap(find.text('Товар 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('В корзину'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Увеличить'));
    await tester.pumpAndSettle();
    expect(cart.state.itemFor(1)?.quantity, 2);

    await tester.tap(find.byTooltip('Уменьшить'));
    await tester.pumpAndSettle();
    expect(cart.state.itemFor(1)?.quantity, 1);

    await tester.tap(find.byTooltip('Удалить'));
    await tester.pumpAndSettle();
    expect(cart.state.isEmpty, isTrue);
    expect(find.text('В корзину'), findsOneWidget);
    expect(find.byTooltip('Увеличить'), findsNothing);
  });

  testWidgets('лист фильтров открывается поверх панели', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byTooltip('Фильтры'));
    await tester.pumpAndSettle();

    final sheetBottom = tester.getBottomLeft(find.byType(FilterSheet)).dy;
    final barTop = tester.getTopLeft(find.byType(NavigationBar)).dy;
    expect(sheetBottom, greaterThan(barTop));
  });
}
