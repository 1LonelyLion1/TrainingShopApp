// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:horns_and_hooves_shop_app/core/database/app_database.dart'
    as _i888;
import 'package:horns_and_hooves_shop_app/core/di/app_module.dart' as _i215;
import 'package:horns_and_hooves_shop_app/core/network/connectivity_service.dart'
    as _i649;
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_repository_impl.dart'
    as _i82;
import 'package:horns_and_hooves_shop_app/features/cart/domain/cart_repository.dart'
    as _i357;
import 'package:horns_and_hooves_shop_app/features/cart/domain/usecases/get_cart.dart'
    as _i14;
import 'package:horns_and_hooves_shop_app/features/cart/domain/usecases/save_cart.dart'
    as _i49;
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_cubit.dart'
    as _i891;
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_api.dart'
    as _i673;
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_cache.dart'
    as _i713;
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_repository_impl.dart'
    as _i105;
import 'package:horns_and_hooves_shop_app/features/catalog/domain/catalog_repository.dart'
    as _i209;
import 'package:horns_and_hooves_shop_app/features/catalog/domain/usecases/get_cached_catalog.dart'
    as _i873;
import 'package:horns_and_hooves_shop_app/features/catalog/domain/usecases/refresh_catalog.dart'
    as _i909;
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/catalog_cubit.dart'
    as _i598;
import 'package:horns_and_hooves_shop_app/features/checkout/domain/usecases/place_order.dart'
    as _i1012;
import 'package:horns_and_hooves_shop_app/features/checkout/presentation/checkout_cubit.dart'
    as _i371;
import 'package:horns_and_hooves_shop_app/features/settings/data/locale_repository_impl.dart'
    as _i963;
import 'package:horns_and_hooves_shop_app/features/settings/domain/locale_repository.dart'
    as _i281;
import 'package:horns_and_hooves_shop_app/features/settings/domain/usecases/get_saved_language.dart'
    as _i1045;
import 'package:horns_and_hooves_shop_app/features/settings/domain/usecases/save_language.dart'
    as _i36;
import 'package:horns_and_hooves_shop_app/features/settings/presentation/locale_cubit.dart'
    as _i393;
import 'package:injectable/injectable.dart' as _i526;

const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i1012.PlaceOrder>(() => const _i1012.PlaceOrder());
    gh.lazySingleton<_i361.Dio>(() => appModule.dio);
    gh.lazySingleton<_i895.Connectivity>(() => appModule.connectivity);
    gh.lazySingleton<_i673.CatalogApi>(
      () => _i673.DioCatalogApi(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i888.AppDatabase>(
      () => appModule.database,
      registerFor: {_prod},
    );
    gh.lazySingleton<_i649.ConnectivityService>(
      () => _i649.ConnectivityPlusService(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i713.CatalogCache>(
      () => _i713.DriftCatalogCache(gh<_i888.AppDatabase>()),
    );
    gh.lazySingleton<_i281.LocaleRepository>(
      () => _i963.DriftLocaleRepository(gh<_i888.AppDatabase>()),
    );
    gh.lazySingleton<_i357.CartRepository>(
      () => _i82.DriftCartRepository(gh<_i888.AppDatabase>()),
    );
    gh.lazySingleton<_i209.CatalogRepository>(
      () => _i105.CatalogRepositoryImpl(
        api: gh<_i673.CatalogApi>(),
        cache: gh<_i713.CatalogCache>(),
      ),
    );
    gh.factory<_i1045.GetSavedLanguage>(
      () => _i1045.GetSavedLanguage(gh<_i281.LocaleRepository>()),
    );
    gh.factory<_i36.SaveLanguage>(
      () => _i36.SaveLanguage(gh<_i281.LocaleRepository>()),
    );
    gh.factory<_i14.GetCart>(() => _i14.GetCart(gh<_i357.CartRepository>()));
    gh.factory<_i49.SaveCart>(() => _i49.SaveCart(gh<_i357.CartRepository>()));
    gh.factory<_i873.GetCachedCatalog>(
      () => _i873.GetCachedCatalog(gh<_i209.CatalogRepository>()),
    );
    gh.factory<_i909.RefreshCatalog>(
      () => _i909.RefreshCatalog(gh<_i209.CatalogRepository>()),
    );
    gh.lazySingleton<_i598.CatalogCubit>(
      () => _i598.CatalogCubit(
        getCachedCatalog: gh<_i873.GetCachedCatalog>(),
        refreshCatalog: gh<_i909.RefreshCatalog>(),
        connectivity: gh<_i649.ConnectivityService>(),
      ),
    );
    await gh.singletonAsync<_i393.LocaleCubit>(
      () => appModule.localeCubit(
        gh<_i1045.GetSavedLanguage>(),
        gh<_i36.SaveLanguage>(),
      ),
      preResolve: true,
    );
    await gh.singletonAsync<_i891.CartCubit>(
      () => appModule.cartCubit(gh<_i14.GetCart>(), gh<_i49.SaveCart>()),
      preResolve: true,
    );
    gh.factory<_i371.CheckoutCubit>(
      () => _i371.CheckoutCubit(gh<_i891.CartCubit>(), gh<_i1012.PlaceOrder>()),
    );
    return this;
  }
}

class _$AppModule extends _i215.AppModule {}
