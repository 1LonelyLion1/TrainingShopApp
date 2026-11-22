import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/core/database/app_database.dart';
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_storage.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/cart.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_cache.dart';

import '../helpers/fakes.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('DriftCatalogCache', () {
    test('пустая база возвращает пустой список', () async {
      expect(await DriftCatalogCache(db).read(), isEmpty);
    });

    test('сохраняет все поля и порядок товаров', () async {
      final cache = DriftCatalogCache(db);
      final products = [product(id: 5), product(id: 1, priceCents: 10995)];

      await cache.write(products);

      expect(await cache.read(), products);
    });

    test('новая запись полностью заменяет старую', () async {
      final cache = DriftCatalogCache(db);
      await cache.write([product(id: 1), product(id: 2)]);

      await cache.write([product(id: 3)]);

      expect((await cache.read()).map((p) => p.id), [3]);
    });
  });

  group('DriftCartStorage', () {
    test('сохраняет позиции, количество и порядок', () async {
      final storage = DriftCartStorage(db);
      final cart = const Cart()
          .add(product(id: 7))
          .add(product(id: 2))
          .setQuantity(7, 3);

      await storage.write(cart);

      expect(await storage.read(), cart);
    });

    test('очистка удаляет все позиции', () async {
      final storage = DriftCartStorage(db);
      await storage.write(const Cart().add(product()));

      await storage.write(const Cart());

      expect((await storage.read()).isEmpty, isTrue);
    });

    test('корзина не зависит от таблицы каталога', () async {
      final storage = DriftCartStorage(db);
      final cart = const Cart().add(product(id: 1));
      await storage.write(cart);

      await DriftCatalogCache(db).write([product(id: 2)]);

      expect(await storage.read(), cart);
    });

    test('корзина переживает закрытие и открытие базы', () async {
      final dir = await Directory.systemTemp.createTemp('cart_db');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/test.sqlite');
      final cart = const Cart().add(product()).setQuantity(1, 4);

      final first = AppDatabase(NativeDatabase(file));
      await DriftCartStorage(first).write(cart);
      await first.close();

      final second = AppDatabase(NativeDatabase(file));
      addTearDown(second.close);
      expect(await DriftCartStorage(second).read(), cart);
    });
  });
}
