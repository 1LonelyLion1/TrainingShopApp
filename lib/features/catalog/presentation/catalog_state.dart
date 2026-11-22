import 'package:equatable/equatable.dart';

import '../../../core/error/app_failure.dart';
import '../domain/catalog_filter.dart';
import '../domain/product.dart';

enum CatalogStatus { loading, success, empty, error }

class CatalogState extends Equatable {
  const CatalogState({
    this.status = CatalogStatus.loading,
    this.products = const [],
    this.filter = const CatalogFilter(),
    this.failure,
    this.isRefreshing = false,
    this.isOnline = true,
  });

  final CatalogStatus status;
  final List<Product> products;
  final CatalogFilter filter;

  /// При статусе success означает, что показаны данные из кеша.
  final AppFailure? failure;
  final bool isRefreshing;
  final bool isOnline;

  List<Product> get visibleProducts => filter.apply(products);

  List<String> get categories =>
      products.map((product) => product.category).toSet().toList()..sort();

  bool get showsOfflineIndicator => !isOnline || failure is NoConnectionFailure;

  CatalogState copyWith({
    CatalogStatus? status,
    List<Product>? products,
    CatalogFilter? filter,
    AppFailure? Function()? failure,
    bool? isRefreshing,
    bool? isOnline,
  }) => CatalogState(
    status: status ?? this.status,
    products: products ?? this.products,
    filter: filter ?? this.filter,
    failure: failure == null ? this.failure : failure(),
    isRefreshing: isRefreshing ?? this.isRefreshing,
    isOnline: isOnline ?? this.isOnline,
  );

  @override
  List<Object?> get props => [
    status,
    products,
    filter,
    failure,
    isRefreshing,
    isOnline,
  ];
}
