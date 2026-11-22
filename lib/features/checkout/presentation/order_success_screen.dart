import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/message_view.dart';
import '../../../l10n/l10n.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.orderNumber});

  final String orderNumber;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/');
      },
      child: Scaffold(
        body: SafeArea(
          child: MessageView(
            icon: Icons.check_circle_outline,
            title: context.l10n.orderSuccessTitle,
            message: context.l10n.orderNumber(orderNumber),
            actionLabel: context.l10n.backToCatalog,
            onAction: () => context.go('/'),
          ),
        ),
      ),
    );
  }
}
