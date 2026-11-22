import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/core/database/app_database.dart';
import 'package:horns_and_hooves_shop_app/core/di/injection.dart';
import 'package:horns_and_hooves_shop_app/core/network/connectivity_service.dart';
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_api.dart';
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_storage.dart';
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_sync_service.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/cart.dart';
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_api.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_cache.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_repository.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/catalog_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/checkout/presentation/checkout_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/settings/presentation/locale_cubit.dart';

import '../helpers/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    getIt.registerSingleton<AppDatabase>(database);
  });

  tearDown(() async {
    await getIt<CartCubit>().close();
    await getIt<LocaleCubit>().close();
    await getIt.reset();
    await database.close();
  });

  test('граф зависимостей разрешается полностью', () async {
    await configureDependencies(environment: 'test');

    expect(getIt<CatalogApi>(), isA<DioCatalogApi>());
    expect(getIt<CatalogCache>(), isA<DriftCatalogCache>());
    expect(getIt<CartStorage>(), isA<DriftCartStorage>());
    expect(getIt<ConnectivityService>(), isA<ConnectivityPlusService>());
    expect(getIt<CatalogRepository>(), isNotNull);
    expect(getIt<CartApi>(), isA<DioCartApi>());
    expect(getIt<CartSyncService>(), isNotNull);
    expect(identical(getIt<CatalogCubit>(), getIt<CatalogCubit>()), isTrue);
    await getIt<CatalogCubit>().close();
  });

  test('корзина загружается из базы при инициализации', () async {
    final cart = const Cart().add(product()).setQuantity(1, 3);
    await DriftCartStorage(database).write(cart);

    await configureDependencies(environment: 'test');

    expect(getIt<CartCubit>().state, cart);
  });

  test('каждый экран оформления получает свой CheckoutCubit', () async {
    await configureDependencies(environment: 'test');

    final first = getIt<CheckoutCubit>();
    final second = getIt<CheckoutCubit>();

    expect(identical(first, second), isFalse);
    await first.close();
    await second.close();
  });
}
