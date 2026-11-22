import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/cart/domain/cart.dart';
import '../features/cart/presentation/cart_cubit.dart';
import '../l10n/l10n.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  static const _catalogIndex = 0;

  final StatefulNavigationShell navigationShell;

  void _selectTab(int index) => navigationShell.goBranch(
    index,
    // Повторный тап по активной вкладке возвращает к её началу.
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      // Системная кнопка «Назад» сначала возвращает на вкладку каталога.
      canPop: navigationShell.currentIndex == _catalogIndex,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) navigationShell.goBranch(_catalogIndex);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: _CompactBottomInset(
          child: BlocBuilder<CartCubit, Cart>(
            builder: (context, cart) => NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _selectTab,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.storefront_outlined),
                  selectedIcon: const Icon(Icons.storefront),
                  label: l10n.navCatalog,
                ),
                NavigationDestination(
                  icon: _CartIcon(
                    cart: cart,
                    icon: Icons.shopping_cart_outlined,
                  ),
                  selectedIcon: _CartIcon(
                    cart: cart,
                    icon: Icons.shopping_cart,
                  ),
                  label: l10n.navCart,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: l10n.navSettings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Уменьшает системный отступ снизу, оставляя место для полоски «Домой».
class _CompactBottomInset extends StatelessWidget {
  const _CompactBottomInset({required this.child});

  static const _maxBottomInset = 12.0;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        padding: media.padding.copyWith(
          bottom: min(media.padding.bottom, _maxBottomInset),
        ),
      ),
      child: child,
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.cart, required this.icon});

  final Cart cart;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Badge.count(
    count: cart.totalQuantity,
    isLabelVisible: !cart.isEmpty,
    child: Icon(icon),
  );
}
