import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/core/error/app_failure.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_repository.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/domain/catalog_filter.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/domain/product.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/catalog_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/catalog_state.dart';

import '../../helpers/fakes.dart';

CatalogCubit _cubit(
  FakeCatalogApi api, {
  FakeCatalogCache? cache,
  FakeConnectivity? connectivity,
}) => CatalogCubit(
  repository: CatalogRepository(api: api, cache: cache ?? FakeCatalogCache()),
  connectivity: connectivity ?? FakeConnectivity(),
);

void main() {
  test('успешная загрузка даёт success', () async {
    final cubit = _cubit(FakeCatalogApi(() async => [product()]));

    await cubit.start();

    expect(cubit.state.status, CatalogStatus.success);
    expect(cubit.state.products, [product()]);
    expect(cubit.state.failure, isNull);
    await cubit.close();
  });

  test('ошибка сети без кеша даёт error', () async {
    final cubit = _cubit(
      FakeCatalogApi(() async => throw const NoConnectionFailure()),
    );

    await cubit.start();

    expect(cubit.state.status, CatalogStatus.error);
    expect(cubit.state.failure, isA<NoConnectionFailure>());
    await cubit.close();
  });

  test('ошибка сети с кешем показывает товары и индикатор', () async {
    final cubit = _cubit(
      FakeCatalogApi(() async => throw const NoConnectionFailure()),
      cache: FakeCatalogCache([product()]),
    );

    await cubit.start();

    expect(cubit.state.status, CatalogStatus.success);
    expect(cubit.state.products, [product()]);
    expect(cubit.state.showsOfflineIndicator, isTrue);
    await cubit.close();
  });

  test('пустой результат даёт empty', () async {
    final cubit = _cubit(FakeCatalogApi(() async => const []));

    await cubit.start();

    expect(cubit.state.status, CatalogStatus.empty);
    await cubit.close();
  });

  test('повтор после ошибки загружает каталог', () async {
    final api = FakeCatalogApi(() async => throw const ServerFailure(500));
    final cubit = _cubit(api);
    await cubit.start();

    api.handler = () async => [product()];
    await cubit.load();

    expect(cubit.state.status, CatalogStatus.success);
    expect(cubit.state.failure, isNull);
    await cubit.close();
  });

  test('восстановление сети обновляет каталог', () async {
    final connectivity = FakeConnectivity(online: false);
    final api = FakeCatalogApi(() async => throw const NoConnectionFailure());
    final cubit = _cubit(api, connectivity: connectivity);
    await cubit.start();
    expect(cubit.state.status, CatalogStatus.error);

    api.handler = () async => [product()];
    connectivity.set(true);
    await pumpEventQueue();

    expect(api.calls, 2);
    expect(cubit.state.status, CatalogStatus.success);
    expect(cubit.state.showsOfflineIndicator, isFalse);
    await cubit.close();
  });

  test('сеть вернулась во время запроса: выполняется повтор', () async {
    final connectivity = FakeConnectivity(online: false);
    final pending = Completer<List<Product>>();
    final api = FakeCatalogApi(() => pending.future);
    final cubit = _cubit(api, connectivity: connectivity);
    final started = cubit.start();
    await pumpEventQueue();

    api.handler = () async => [product()];
    connectivity.set(true);
    pending.completeError(const NoConnectionFailure());
    await started;

    expect(api.calls, 2);
    expect(cubit.state.products, [product()]);
    await cubit.close();
  });

  test('фильтры работают локально и сбрасываются', () async {
    final api = FakeCatalogApi(
      () async => [
        product(priceCents: 500, category: 'a'),
        product(id: 2, priceCents: 1500, category: 'a'),
        product(id: 3, priceCents: 1500, category: 'b'),
      ],
    );
    final cubit = _cubit(api);
    await cubit.start();

    cubit.applyFilter(
      const CatalogFilter(category: 'a', minCents: 1000, maxCents: 2000),
    );
    expect(cubit.state.visibleProducts.map((p) => p.id), [2]);
    expect(cubit.state.categories, ['a', 'b']);
    expect(api.calls, 1);

    cubit.resetFilter();
    expect(cubit.state.visibleProducts, hasLength(3));
    await cubit.close();
  });

  test('границы диапазона цены включаются', () {
    const filter = CatalogFilter(minCents: 1000, maxCents: 1000);

    expect(filter.matches(product(priceCents: 1000)), isTrue);
    expect(filter.matches(product(priceCents: 1001)), isFalse);
  });
}
