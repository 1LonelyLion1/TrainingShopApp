import 'package:equatable/equatable.dart';

import 'product.dart';

class CatalogFilter extends Equatable {
  const CatalogFilter({this.category, this.minCents, this.maxCents});

  final String? category;
  final int? minCents;
  final int? maxCents;

  bool get isActive => category != null || minCents != null || maxCents != null;

  bool matches(Product product) {
    if (category != null && product.category != category) return false;
    if (minCents != null && product.priceCents < minCents!) return false;
    if (maxCents != null && product.priceCents > maxCents!) return false;
    return true;
  }

  List<Product> apply(List<Product> products) =>
      products.where(matches).toList(growable: false);

  @override
  List<Object?> get props => [category, minCents, maxCents];
}
