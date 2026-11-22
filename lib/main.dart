import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
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
  unawaited(catalog.start());
}
