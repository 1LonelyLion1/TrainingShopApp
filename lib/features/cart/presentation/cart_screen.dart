import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/money.dart';
import '../../../core/widgets/message_view.dart';
import '../../../core/widgets/product_image.dart';
import '../../../l10n/l10n.dart';
import '../domain/cart.dart';
import 'cart_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.cartTitle)),
      body: BlocBuilder<CartCubit, Cart>(
        builder: (context, cart) {
          if (cart.isEmpty) {
            return MessageView(
              icon: Icons.shopping_cart_outlined,
              title: context.l10n.cartEmpty,
              actionLabel: context.l10n.goToCatalog,
              onAction: () => context.go('/'),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, index) => _CartRow(item: cart.items[index]),
                ),
              ),
              _CartSummary(totalCents: cart.totalCents),
            ],
          );
        },
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<CartCubit>();
    final id = item.product.id;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/cart/product/$id'),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                color: Colors.white,
                padding: const EdgeInsets.all(4),
                child: ProductImage(url: item.product.imageUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatCents(item.totalCents),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          tooltip: context.l10n.cartDecrease,
                          onPressed: item.quantity > 1
                              ? () => cubit.decrement(id)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          tooltip: context.l10n.cartIncrease,
                          onPressed: item.quantity < Cart.maxQuantity
                              ? () => cubit.increment(id)
                              : null,
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: context.l10n.cartRemove,
                          onPressed: () => cubit.remove(id),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.totalCents});

  final int totalCents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.cartTotal,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    formatCents(totalCents),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => context.push('/checkout'),
                child: Text(context.l10n.cartCheckout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
