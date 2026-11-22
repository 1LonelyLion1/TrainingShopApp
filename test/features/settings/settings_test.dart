import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/app/app.dart';
import 'package:horns_and_hooves_shop_app/core/database/app_database.dart';
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_storage.dart';
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_repository.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/catalog_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/settings/data/locale_storage.dart';
import 'package:horns_and_hooves_shop_app/features/settings/presentation/locale_cubit.dart';

import '../../helpers/fakes.dart';

Future<FakeLocaleStorage> _pumpApp(WidgetTester tester, String? saved) async {
  final storage = FakeLocaleStorage(saved);
  final catalog = CatalogCubit(
    repository: CatalogRepository(
      api: FakeCatalogApi(() async => [product()]),
      cache: FakeCatalogCache(),
    ),
    connectivity: FakeConnectivity(),
  );
  final cart = CartCubit(FakeCartStorage());
  final locale = LocaleCubit(storage, LocaleCubit.parse(saved));
  addTearDown(catalog.close);
  addTearDown(cart.close);
  addTearDown(locale.close);

  await tester.pumpWidget(
    ShopApp(catalog: catalog, cart: cart, locale: locale),
  );
  await catalog.start();
  await tester.pumpAndSettle();
  return storage;
}

Finder _tab(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

void main() {
  testWidgets('смена языка сразу меняет интерфейс и сохраняется', (
    tester,
  ) async {
    final storage = await _pumpApp(tester, 'ru');

    await tester.tap(_tab('Настройки'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(_tab('Settings'), findsOneWidget);
    expect(_tab('Catalog'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(storage.saved, 'en');

    await tester.tap(find.text('Русский'));
    await tester.pumpAndSettle();

    expect(_tab('Настройки'), findsOneWidget);
    expect(storage.saved, 'ru');
  });

  testWidgets('смена языка не сбрасывает активную вкладку', (tester) async {
    await _pumpApp(tester, 'ru');
    await tester.tap(_tab('Настройки'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 2);
  });

  testWidgets('системный язык очищает сохранённый выбор', (tester) async {
    final storage = await _pumpApp(tester, 'ru');
    await tester.tap(_tab('Настройки'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Системный'));
    await tester.pumpAndSettle();

    expect(storage.saved, isNull);
    // В тестовом окружении системный язык — английский.
    expect(_tab('Settings'), findsOneWidget);
  });

  test('неизвестный код языка сводится к системному', () {
    expect(LocaleCubit.parse('de'), isNull);
    expect(LocaleCubit.parse(null), isNull);
    expect(LocaleCubit.parse('en'), const Locale('en'));
  });

  test('английский перевод содержит все ключи русского', () {
    Set<String> keys(String path) =>
        (jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>).keys
            .where((key) => !key.startsWith('@'))
            .toSet();

    expect(keys('lib/l10n/app_en.arb'), keys('lib/l10n/app_ru.arb'));
  });

  group('DriftLocaleStorage', () {
    late AppDatabase db;

    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('сохраняет, заменяет и очищает язык', () async {
      final storage = DriftLocaleStorage(db);
      expect(await storage.read(), isNull);

      await storage.write('en');
      await storage.write('ru');
      expect(await storage.read(), 'ru');

      await storage.write(null);
      expect(await storage.read(), isNull);
    });
  });

  test('миграция с версии 1 сохраняет корзину', () async {
    final db = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute('''
            CREATE TABLE catalog_products (
              product_id INTEGER NOT NULL PRIMARY KEY, title TEXT NOT NULL,
              price_cents INTEGER NOT NULL, description TEXT NOT NULL,
              category TEXT NOT NULL, image_url TEXT NOT NULL,
              rating REAL NOT NULL, rating_count INTEGER NOT NULL,
              position INTEGER NOT NULL
            );
            CREATE TABLE cart_items (
              product_id INTEGER NOT NULL PRIMARY KEY, title TEXT NOT NULL,
              price_cents INTEGER NOT NULL, description TEXT NOT NULL,
              category TEXT NOT NULL, image_url TEXT NOT NULL,
              rating REAL NOT NULL, rating_count INTEGER NOT NULL,
              position INTEGER NOT NULL, quantity INTEGER NOT NULL
            );
            INSERT INTO cart_items VALUES
              (7, 'Товар', 1050, 'Описание', 'electronics', '', 4.5, 10, 0, 3);
            PRAGMA user_version = 1;
          ''');
        },
      ),
    );
    addTearDown(db.close);

    final cart = await DriftCartStorage(db).read();
    await DriftLocaleStorage(db).write('en');

    expect(cart.itemFor(7)?.quantity, 3);
    expect(await DriftLocaleStorage(db).read(), 'en');
  });
}
