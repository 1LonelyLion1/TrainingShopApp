import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/cart/presentation/cart_screen.dart';
import '../features/catalog/presentation/catalog_screen.dart';
import '../features/catalog/presentation/product_details_screen.dart';
import '../features/checkout/presentation/checkout_screen.dart';
import '../features/checkout/presentation/order_success_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import 'main_shell.dart';

/// Экран товара вложен в каждую вкладку: панель остаётся видимой,
/// а «Назад» возвращает туда, откуда товар был открыт.
GoRoute _productRoute() => GoRoute(
  path: 'product/:id',
  builder: (BuildContext _, GoRouterState state) => ProductDetailsScreen(
    productId: int.tryParse(state.pathParameters['id'] ?? ''),
  ),
);

GoRouter createRouter() => GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (_, _, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const CatalogScreen(),
              routes: [_productRoute()],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (_, _) => const CartScreen(),
              routes: [_productRoute()],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (_, _) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    // Оформление заказа открывается на весь экран, без нижней панели.
    GoRoute(path: '/checkout', builder: (_, _) => const CheckoutScreen()),
    GoRoute(
      path: '/order-success/:number',
      builder: (_, state) =>
          OrderSuccessScreen(orderNumber: state.pathParameters['number']!),
    ),
  ],
);
