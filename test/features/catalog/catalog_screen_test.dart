import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:horns_and_hooves_shop_app/core/error/app_failure.dart';
import 'package:horns_and_hooves_shop_app/core/error/app_failure_l10n.dart';
import 'package:horns_and_hooves_shop_app/features/cart/presentation/cart_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_repository.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/domain/product.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/catalog_cubit.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/presentation/catalog_screen.dart';
import 'package:horns_and_hooves_shop_app/l10n/l10n.dart';

import '../../helpers/fakes.dart';

Future<CatalogCubit> _pump(
  WidgetTester tester,
  FakeCatalogApi api, {
  FakeCatalogCache? cache,
}) async {
  final catalog = CatalogCubit(
    repository: CatalogRepository(api: api, cache: cache ?? FakeCatalogCache()),
    connectivity: FakeConnectivity(),
  );
  final cart = CartCubit(FakeCartStorage());
  addTearDown(catalog.close);
  addTearDown(cart.close);
  final router = GoRouter(
    routes: [GoRoute(path: '/', builder: (_, _) => const CatalogScreen())],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: catalog),
        BlocProvider.value(value: cart),
      ],
      child: MaterialApp.router(
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: router,
      ),
    ),
  );
  unawaited(catalog.start());
  await tester.pump();
  return catalog;
}

void main() {
  testWidgets('Loading: показывает индикатор', (tester) async {
    final pending = Completer<List<Product>>();
    await _pump(tester, FakeCatalogApi(() => pending.future));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    pending.complete(const []);
    await tester.pumpAndSettle();
  });

  testWidgets('Success: показывает товар', (tester) async {
    await _pump(tester, FakeCatalogApi(() async => [product()]));
    await tester.pumpAndSettle();

    expect(find.text('Товар 1'), findsOneWidget);
    expect(find.text('\$10.00'), findsOneWidget);
    expect(find.text('Электроника'), findsOneWidget);
  });

  testWidgets('Error: сообщение и рабочая кнопка «Повторить»', (tester) async {
    final api = FakeCatalogApi(() async => throw const ServerFailure(503));
    await _pump(tester, api);
    await tester.pumpAndSettle();

    expect(
      find.text(
        const ServerFailure(
          503,
        ).localized(lookupAppLocalizations(const Locale('ru'))),
      ),
      findsOneWidget,
    );

    api.handler = () async => [product()];
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();

    expect(find.text('Товар 1'), findsOneWidget);
  });

  testWidgets('Empty: показывает пустой каталог', (tester) async {
    await _pump(tester, FakeCatalogApi(() async => const []));
    await tester.pumpAndSettle();

    expect(find.text('Каталог пуст'), findsOneWidget);
  });

  testWidgets('Офлайн: кеш и индикатор «Нет соединения»', (tester) async {
    await _pump(
      tester,
      FakeCatalogApi(() async => throw const NoConnectionFailure()),
      cache: FakeCatalogCache([product()]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Товар 1'), findsOneWidget);
    expect(find.textContaining('Нет соединения'), findsOneWidget);
  });
}
