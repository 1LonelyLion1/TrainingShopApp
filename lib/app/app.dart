import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/cart/presentation/cart_cubit.dart';
import '../features/catalog/presentation/catalog_cubit.dart';
import '../features/settings/presentation/locale_cubit.dart';
import '../l10n/l10n.dart';
import 'router.dart';

class ShopApp extends StatefulWidget {
  const ShopApp({
    super.key,
    required this.catalog,
    required this.cart,
    required this.locale,
  });

  final CatalogCubit catalog;
  final CartCubit cart;
  final LocaleCubit locale;

  @override
  State<ShopApp> createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> {
  late final GoRouter _router = createRouter();

  // Система может завершить приложение в фоне, не дождавшись таймера корзины.
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    onStateChange: (state) {
      if (state != AppLifecycleState.resumed) widget.cart.flush();
    },
  );

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.catalog),
        BlocProvider.value(value: widget.cart),
        BlocProvider.value(value: widget.locale),
      ],
      child: BlocBuilder<LocaleCubit, Locale?>(
        builder: (context, locale) => MaterialApp.router(
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.brown,
              brightness: Brightness.dark,
            ),
          ),
          routerConfig: _router,
        ),
      ),
    );
  }
}
