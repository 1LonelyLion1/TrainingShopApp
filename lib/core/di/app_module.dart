import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../features/cart/data/cart_storage.dart';
import '../../features/cart/presentation/cart_cubit.dart';
import '../../features/catalog/data/catalog_api.dart';
import '../../features/settings/data/locale_storage.dart';
import '../../features/settings/presentation/locale_cubit.dart';
import '../database/app_database.dart';

/// Регистрирует внешние классы и объекты с асинхронной инициализацией.
@module
abstract class AppModule {
  @lazySingleton
  Dio get dio => DioCatalogApi.createDio();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  /// В тестах вместо файловой базы регистрируется база в памяти.
  @prod
  @lazySingleton
  AppDatabase get database => AppDatabase();

  /// Корзина читается до старта UI, чтобы ранние действия её не перезаписали.
  @preResolve
  @singleton
  Future<CartCubit> cartCubit(CartStorage storage) async =>
      CartCubit(storage, await storage.read());

  /// Язык читается до старта UI, чтобы интерфейс не мигал другим языком.
  @preResolve
  @singleton
  Future<LocaleCubit> localeCubit(LocaleStorage storage) async =>
      LocaleCubit(storage, LocaleCubit.parse(await storage.read()));
}
