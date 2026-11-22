import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/app_failure_l10n.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/message_view.dart';
import '../../../core/widgets/product_image.dart';
import '../../../l10n/l10n.dart';
import '../../cart/presentation/cart_quantity_control.dart';
import '../domain/product.dart';
import 'catalog_cubit.dart';
import 'catalog_state.dart';
import 'category_label.dart';
import 'filter_sheet.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  Future<void> _openFilters(BuildContext context) async {
    final cubit = context.read<CatalogCubit>();
    final result = await showFilterSheet(
      context,
      filter: cubit.state.filter,
      categories: cubit.state.categories,
    );
    if (result != null) cubit.applyFilter(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: [
          BlocBuilder<CatalogCubit, CatalogState>(
            buildWhen: (a, b) =>
                a.filter != b.filter || a.products != b.products,
            builder: (context, state) => IconButton(
              tooltip: context.l10n.filtersTooltip,
              onPressed: state.products.isEmpty
                  ? null
                  : () => _openFilters(context),
              icon: Badge(
                isLabelVisible: state.filter.isActive,
                smallSize: 8,
                child: const Icon(Icons.tune),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) => Column(
          children: [
            if (state.showsOfflineIndicator)
              _StatusBanner(
                icon: Icons.wifi_off,
                text: state.products.isEmpty
                    ? context.l10n.offlineNoData
                    : context.l10n.offlineWithCache,
              )
            else if (state.status == CatalogStatus.success &&
                state.failure != null)
              _StatusBanner(
                icon: Icons.warning_amber,
                text: state.failure!.localized(context.l10n),
              ),
            Expanded(child: _CatalogBody(state: state)),
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: ColoredBox(
        color: colors.errorContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 18, color: colors.onErrorContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: colors.onErrorContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({required this.state});

  final CatalogState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CatalogCubit>();
    switch (state.status) {
      case CatalogStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case CatalogStatus.error:
        return MessageView(
          icon: state.failure is NoConnectionFailure
              ? Icons.wifi_off
              : Icons.error_outline,
          title: context.l10n.catalogLoadError,
          message: (state.failure ?? const UnknownFailure()).localized(
            context.l10n,
          ),
          actionLabel: context.l10n.retry,
          onAction: cubit.load,
        );
      case CatalogStatus.empty:
        return MessageView(
          icon: Icons.inventory_2_outlined,
          title: context.l10n.catalogEmptyTitle,
          message: context.l10n.catalogEmptyMessage,
          actionLabel: context.l10n.refresh,
          onAction: cubit.load,
        );
      case CatalogStatus.success:
        final products = state.visibleProducts;
        if (products.isEmpty) {
          return MessageView(
            icon: Icons.search_off,
            title: context.l10n.nothingFoundTitle,
            message: context.l10n.nothingFoundMessage,
            actionLabel: context.l10n.resetFilters,
            onAction: cubit.resetFilter,
          );
        }
        return RefreshIndicator(
          onRefresh: cubit.load,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisExtent: 350,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (_, index) => _ProductCard(product: products[index]),
          ),
        );
    }
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/product/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: ProductImage(url: product.imageUrl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryLabel(context.l10n, product.category),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 40,
                    child: Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatCents(product.priceCents),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CartQuantityControl(product: product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
