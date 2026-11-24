import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/core/error/app_failure.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_repository_impl.dart';

import '../../helpers/fakes.dart';

void main() {
  test('успешная загрузка возвращает товары и пишет кеш', () async {
    final cache = FakeCatalogCache();
    final repository = CatalogRepositoryImpl(
      api: FakeCatalogApi(() async => [product()]),
      cache: cache,
    );

    expect(await repository.refresh(), [product()]);
    expect(cache.products, [product()]);
  });

  test('ошибка сети пробрасывается и не трогает кеш', () async {
    final cache = FakeCatalogCache([product()]);
    final repository = CatalogRepositoryImpl(
      api: FakeCatalogApi(() async => throw const NoConnectionFailure()),
      cache: cache,
    );

    await expectLater(
      repository.refresh(),
      throwsA(isA<NoConnectionFailure>()),
    );
    expect(cache.products, [product()]);
  });

  test('пустой результат не стирает кеш', () async {
    final cache = FakeCatalogCache([product()]);
    final repository = CatalogRepositoryImpl(
      api: FakeCatalogApi(() async => const []),
      cache: cache,
    );

    expect(await repository.refresh(), isEmpty);
    expect(cache.products, [product()]);
    expect(cache.writes, 0);
  });

  test('сбой записи кеша не скрывает свежие данные', () async {
    final cache = FakeCatalogCache()..failOnWrite = true;
    final repository = CatalogRepositoryImpl(
      api: FakeCatalogApi(() async => [product()]),
      cache: cache,
    );

    expect(await repository.refresh(), [product()]);
  });
}
