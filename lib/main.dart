import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'features/cart/data/cart_sync_service.dart';
import 'features/cart/presentation/cart_cubit.dart';
import 'features/catalog/presentation/catalog_cubit.dart';
import 'features/settings/presentation/locale_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await configureDependencies();

  final catalog = getIt<CatalogCubit>();
  runApp(
    ShopApp(
      catalog: catalog,
      cart: getIt<CartCubit>(),
      locale: getIt<LocaleCubit>(),
    ),
  );
  unawaited(_startData(catalog));
}

/// Корзине нужны данные товаров, поэтому она синхронизируется после каталога.
Future<void> _startData(CatalogCubit catalog) async {
  await catalog.start();
  await getIt<CartSyncService>().start();
}
