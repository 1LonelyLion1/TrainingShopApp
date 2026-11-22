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
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_storage.dart'
    as _i139;
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_cubit.dart'
    as _i891;
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_api.dart'
    as _i673;
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_cache.dart'
    as _i713;
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_repository.dart'
    as _i89;
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/catalog_cubit.dart'
    as _i598;
import 'package:horns_and_hooves_shop_app/features/checkout/presentation/checkout_cubit.dart'
    as _i371;
import 'package:horns_and_hooves_shop_app/features/settings/data/locale_storage.dart'
    as _i947;
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
    gh.lazySingleton<_i139.CartStorage>(
      () => _i139.DriftCartStorage(gh<_i888.AppDatabase>()),
    );
    gh.lazySingleton<_i89.CatalogRepository>(
      () => _i89.CatalogRepository(
        api: gh<_i673.CatalogApi>(),
        cache: gh<_i713.CatalogCache>(),
      ),
    );
    gh.lazySingleton<_i947.LocaleStorage>(
      () => _i947.DriftLocaleStorage(gh<_i888.AppDatabase>()),
    );
    await gh.singletonAsync<_i891.CartCubit>(
      () => appModule.cartCubit(gh<_i139.CartStorage>()),
      preResolve: true,
    );
    gh.lazySingleton<_i598.CatalogCubit>(
      () => _i598.CatalogCubit(
        repository: gh<_i89.CatalogRepository>(),
        connectivity: gh<_i649.ConnectivityService>(),
      ),
    );
    await gh.singletonAsync<_i393.LocaleCubit>(
      () => appModule.localeCubit(gh<_i947.LocaleStorage>()),
      preResolve: true,
    );
    gh.factory<_i371.CheckoutCubit>(
      () => _i371.CheckoutCubit(gh<_i891.CartCubit>()),
    );
    return this;
  }
}

class _$AppModule extends _i215.AppModule {}
