import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';
import '../../catalog/domain/product.dart';
import '../domain/cart.dart';
import 'cart_cubit.dart';

/// Кнопка «В корзину», которая после добавления становится счётчиком.
/// При количестве 1 кнопка уменьшения превращается в удаление.
class CartQuantityControl extends StatelessWidget {
  const CartQuantityControl({
    super.key,
    required this.product,
    this.height = 40,
  });

  final Product product;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartCubit, Cart, int>(
      selector: (cart) => cart.itemFor(product.id)?.quantity ?? 0,
      builder: (context, quantity) {
        final l10n = context.l10n;
        final cubit = context.read<CartCubit>();
        if (quantity == 0) {
          return SizedBox(
            width: double.infinity,
            height: height,
            child: FilledButton.tonalIcon(
              onPressed: () => cubit.add(product),
              icon: const Icon(Icons.add_shopping_cart, size: 18),
              label: Text(
                l10n.addToCart,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }

        final isLast = quantity == 1;
        return SizedBox(
          height: height,
          child: Row(
            children: [
              _StepButton(
                size: height,
                icon: isLast ? Icons.delete_outline : Icons.remove,
                tooltip: isLast ? l10n.cartRemove : l10n.cartDecrease,
                onPressed: isLast
                    ? () => cubit.remove(product.id)
                    : () => cubit.decrement(product.id),
              ),
              Expanded(
                child: Semantics(
                  label: l10n.inCart(quantity),
                  excludeSemantics: true,
                  child: Center(
                    child: Text(
                      '$quantity',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
              _StepButton(
                size: height,
                icon: Icons.add,
                tooltip: l10n.cartIncrease,
                onPressed: quantity >= Cart.maxQuantity
                    ? null
                    : () => cubit.increment(product.id),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.size,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final double size;
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: IconButton.filledTonal(
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
    ),
  );
}
