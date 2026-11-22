import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/message_view.dart';
import '../../../l10n/l10n.dart';
import '../../cart/presentation/cart_cubit.dart';
import '../domain/checkout_validators.dart';
import 'checkout_error_l10n.dart';
import 'checkout_cubit.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CheckoutCubit>(),
      child: BlocConsumer<CheckoutCubit, CheckoutState>(
        listenWhen: (a, b) => a.orderNumber != b.orderNumber,
        listener: (context, state) =>
            context.go('/order-success/${state.orderNumber}'),
        builder: (context, state) {
          final cart = context.watch<CartCubit>().state;
          if (cart.isEmpty && state.orderNumber == null) {
            return Scaffold(
              appBar: AppBar(title: Text(context.l10n.checkoutTitle)),
              body: MessageView(
                icon: Icons.shopping_cart_outlined,
                title: context.l10n.cartEmpty,
                actionLabel: context.l10n.goToCatalog,
                onAction: () => context.go('/'),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.checkoutTitle)),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Field(
                  field: CheckoutField.name,
                  label: context.l10n.fieldName,
                  keyboardType: TextInputType.name,
                  autofillHint: AutofillHints.name,
                ),
                _Field(
                  field: CheckoutField.email,
                  label: context.l10n.fieldEmail,
                  keyboardType: TextInputType.emailAddress,
                  autofillHint: AutofillHints.email,
                ),
                _Field(
                  field: CheckoutField.phone,
                  label: context.l10n.fieldPhone,
                  keyboardType: TextInputType.phone,
                  autofillHint: AutofillHints.telephoneNumber,
                ),
                _Field(
                  field: CheckoutField.address,
                  label: context.l10n.fieldAddress,
                  keyboardType: TextInputType.streetAddress,
                  autofillHint: AutofillHints.fullStreetAddress,
                  isLast: true,
                ),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: state.isValid
                      ? context.read<CheckoutCubit>().submit
                      : null,
                  child: Text(
                    context.l10n.checkoutSubmit(formatCents(cart.totalCents)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.field,
    required this.label,
    required this.keyboardType,
    required this.autofillHint,
    this.isLast = false,
  });

  final CheckoutField field;
  final String label;
  final TextInputType keyboardType;
  final String autofillHint;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();
    final error = context.select<CheckoutCubit, CheckoutFieldError?>(
      (cubit) => cubit.state.errorFor(field),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Focus(
        onFocusChange: (focused) {
          if (!focused) cubit.blurred(field);
        },
        child: TextField(
          onChanged: (value) => cubit.changed(field, value),
          keyboardType: keyboardType,
          autofillHints: [autofillHint],
          textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
          decoration: InputDecoration(
            labelText: label,
            errorText: error?.localized(context.l10n),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
