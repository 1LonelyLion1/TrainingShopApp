import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/core/database/app_database.dart';
import 'package:horns_and_hooves_shop_app/core/error/app_failure.dart';
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_api.dart';
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_storage.dart';
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_sync_service.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/cart.dart';
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_repository.dart';

import '../../helpers/fakes.dart';

class _Harness {
  _Harness({
    FakeCartApi? api,
    FakeCartStorage? storage,
    Cart initial = const Cart(),
    bool online = true,
  }) : api = api ?? FakeCartApi(),
       storage = storage ?? FakeCartStorage(),
       connectivity = FakeConnectivity(online: online) {
    cart = CartCubit(this.storage, initial, Duration.zero);
    service = CartSyncService(
      this.api,
      this.storage,
      CatalogRepository(
        api: FakeCatalogApi(() async => [product(), product(id: 2)]),
        cache: FakeCatalogCache([product(), product(id: 2)]),
      ),
      cart,
      connectivity,
    );
  }

  final FakeCartApi api;
  final FakeCartStorage storage;
  final FakeConnectivity connectivity;
  late final CartCubit cart;
  late final CartSyncService service;

  Future<void> dispose() async {
    await service.dispose();
    await cart.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('первый запуск импортирует корзину с сервера', () async {
    final h = _Harness(
      api: FakeCartApi(
        remote: const [
          CartLine(productId: 2, quantity: 3),
          CartLine(productId: 404, quantity: 1),
          CartLine(productId: 1, quantity: 500),
        ],
      ),
    );

    await h.service.start();

    expect(h.cart.state.itemFor(2)?.quantity, 3);
    expect(h.cart.state.itemFor(1)?.quantity, Cart.maxQuantity);
    expect(h.cart.state.contains(404), isFalse);
    expect(h.storage.saved, h.cart.state);
    expect(h.api.updates, isEmpty);
    await h.dispose();
  });

  test('следующий запуск не затирает корзину данными сервера', () async {
    final storage = FakeCartStorage()
      ..saved = const Cart()
      ..syncedRevision = 0;
    final api = FakeCartApi(
      remote: const [CartLine(productId: 1, quantity: 4)],
    );
    final h = _Harness(api: api, storage: storage);

    await h.service.start();

    expect(api.fetchCalls, 0);
    expect(h.cart.state.isEmpty, isTrue);
    await h.dispose();
  });

  test('непустая локальная корзина отправляется без импорта', () async {
    final storage = FakeCartStorage();
    await storage.write(const Cart().add(product()));
    final api = FakeCartApi(
      remote: const [CartLine(productId: 2, quantity: 1)],
    );
    final h = _Harness(api: api, storage: storage, initial: storage.saved);

    await h.service.start();

    expect(api.fetchCalls, 0);
    expect(api.updates.single, const [CartLine(productId: 1, quantity: 1)]);
    expect(storage.syncedRevision, storage.localRevision);
    await h.dispose();
  });

  test('изменение корзины отправляется на сервер', () async {
    final h = _Harness();
    await h.service.start();

    await h.cart.add(product());
    await pumpEventQueue();

    expect(h.api.updates.single, const [CartLine(productId: 1, quantity: 1)]);
    expect(h.storage.syncedRevision, h.storage.localRevision);
    await h.dispose();
  });

  test('очистка корзины отправляет пустой список', () async {
    final h = _Harness();
    await h.service.start();
    await h.cart.add(product());
    await pumpEventQueue();

    await h.cart.clear();
    await pumpEventQueue();

    expect(h.api.updates.last, isEmpty);
    await h.dispose();
  });

  test('офлайн: запросов нет, после возврата сети корзина уходит', () async {
    final h = _Harness(online: false);
    await h.service.start();

    await h.cart.add(product());
    h.cart.increment(1);
    await h.cart.flush();
    await pumpEventQueue();
    expect(h.api.fetchCalls, 0);
    expect(h.api.updates, isEmpty);
    expect(h.storage.saved.itemFor(1)?.quantity, 2);

    h.connectivity.set(true);
    await pumpEventQueue();

    expect(h.api.updates.single, const [CartLine(productId: 1, quantity: 2)]);
    expect(h.storage.syncedRevision, h.storage.localRevision);
    await h.dispose();
  });

  test('ошибка сервера оставляет изменения неотправленными', () async {
    final h = _Harness();
    await h.service.start();
    h.api.failure = const ServerFailure(503);

    await h.cart.add(product());
    await pumpEventQueue();
    expect(h.storage.syncedRevision, isNot(h.storage.localRevision));
    expect(h.cart.state.contains(1), isTrue);

    h.api.failure = null;
    await h.service.sync();

    expect(h.api.updates.single, const [CartLine(productId: 1, quantity: 1)]);
    expect(h.storage.syncedRevision, h.storage.localRevision);
    await h.dispose();
  });

  test('ошибка импорта повторяется при следующей синхронизации', () async {
    final api = FakeCartApi(remote: const [CartLine(productId: 1, quantity: 2)])
      ..failure = const TimeoutFailure();
    final h = _Harness(api: api);
    await h.service.start();
    expect(h.cart.state.isEmpty, isTrue);

    api.failure = null;
    await h.service.sync();

    expect(h.cart.state.itemFor(1)?.quantity, 2);
    await h.dispose();
  });

  test('изменение во время PUT отправляется следующим запросом', () async {
    final h = _Harness();
    await h.service.start();
    final gate = Completer<void>();
    h.api.updateGate = gate;

    await h.cart.add(product());
    await pumpEventQueue();
    expect(h.api.updates, hasLength(1));

    h.api.updateGate = null;
    await h.cart.add(product(id: 2));
    await pumpEventQueue();
    expect(h.api.updates, hasLength(1));

    gate.complete();
    await pumpEventQueue();

    expect(h.api.updates, hasLength(2));
    expect(h.api.updates.last, hasLength(2));
    expect(h.storage.syncedRevision, h.storage.localRevision);
    await h.dispose();
  });

  test('повторная синхронизация без изменений не вызывает PUT', () async {
    final h = _Harness();
    await h.service.start();
    await h.cart.add(product());
    await pumpEventQueue();

    await h.service.sync();
    await h.service.sync();

    expect(h.api.updates, hasLength(1));
    await h.dispose();
  });

  group('DriftCartStorage: ревизии', () {
    late AppDatabase db;
    late DriftCartStorage storage;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      storage = DriftCartStorage(db);
    });
    tearDown(() => db.close());

    test('запись увеличивает ревизию, markSynced её фиксирует', () async {
      await storage.write(const Cart().add(product()));
      await storage.write(const Cart().add(product()).add(product()));

      var snapshot = await storage.readSyncSnapshot();
      expect(snapshot.localRevision, 2);
      expect(snapshot.syncedRevision, isNull);
      expect(snapshot.cart.itemFor(1)?.quantity, 2);

      await storage.markSynced(2);
      snapshot = await storage.readSyncSnapshot();
      expect(snapshot.syncedRevision, 2);
    });

    test('импорт работает только один раз', () async {
      final remote = const Cart().add(product());

      expect(await storage.importRemote(remote), isTrue);
      expect(await storage.read(), remote);
      expect((await storage.readSyncSnapshot()).syncedRevision, 0);

      expect(await storage.importRemote(const Cart()), isFalse);
      expect(await storage.read(), remote);
    });

    test('импорт не затирает локальные изменения', () async {
      final local = const Cart().add(product(id: 2));
      await storage.write(local);

      expect(await storage.importRemote(const Cart().add(product())), isFalse);
      expect(await storage.read(), local);
    });
  });
}
