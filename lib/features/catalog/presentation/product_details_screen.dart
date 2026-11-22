import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/money.dart';
import '../../../core/widgets/message_view.dart';
import '../../../core/widgets/product_image.dart';
import '../../../l10n/l10n.dart';
import '../../cart/domain/cart.dart';
import '../../cart/presentation/cart_cubit.dart';
import '../../cart/presentation/cart_quantity_control.dart';
import '../domain/product.dart';
import 'catalog_cubit.dart';
import 'catalog_state.dart';
import 'category_label.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final int? productId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, _) {
        final id = productId;
        // Товар из корзины остаётся доступен, даже если исчез из каталога.
        final product = id == null
            ? null
            : context.read<CatalogCubit>().productById(id) ??
                  context.read<CartCubit>().state.itemFor(id)?.product;
        if (product == null) {
          return Scaffold(
            appBar: AppBar(),
            body: MessageView(
              icon: Icons.search_off,
              title: context.l10n.productNotFound,
              actionLabel: context.l10n.goToCatalog,
              onAction: () => context.go('/'),
            ),
          );
        }
        return _Details(product: product);
      },
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryLabel(context.l10n, product.category)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          Container(
            height: 320,
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: ProductImage(url: product.imageUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(categoryLabel(context.l10n, product.category)),
                ),
                const SizedBox(height: 8),
                Text(product.title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      formatCents(product.priceCents),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating.toStringAsFixed(1)} '
                      '(${product.ratingCount})',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(product.description, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocSelector<CartCubit, Cart, bool>(
            selector: (cart) => cart.contains(product.id),
            builder: (context, isInCart) {
              final control = CartQuantityControl(product: product, height: 48);
              if (!isInCart) return control;
              return Row(
                children: [
                  Expanded(child: control),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: () => context.go('/cart'),
                        child: Text(
                          context.l10n.goToCart,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
