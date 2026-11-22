import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart' show lazySingleton;

import '../../../core/error/app_failure.dart';
import '../../../core/network/connectivity_service.dart';
import '../data/catalog_repository.dart';
import '../domain/catalog_filter.dart';
import '../domain/product.dart';
import 'catalog_state.dart';

@lazySingleton
class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit({required this._repository, required this._connectivity})
    : super(const CatalogState());

  final CatalogRepository _repository;
  final ConnectivityService _connectivity;

  StreamSubscription<bool>? _connectivitySubscription;
  bool _isLoading = false;
  bool _reloadQueued = false;

  Future<void> start() async {
    _connectivitySubscription ??= _connectivity.onlineChanges.listen(
      _onOnlineChanged,
    );
    final online = await _connectivity.isOnline;
    if (isClosed) return;
    emit(state.copyWith(isOnline: online));
    await load();
  }

  Future<void> load() async {
    if (_isLoading) {
      _reloadQueued = true;
      return;
    }
    _isLoading = true;
    try {
      await _showCachedIfNeeded();
      if (isClosed) return;
      emit(state.copyWith(isRefreshing: true));

      final products = await _repository.refresh();
      if (isClosed) return;
      _emitLoaded(products);
    } on AppFailure catch (failure) {
      if (!isClosed) _emitFailure(failure);
    } finally {
      _isLoading = false;
    }

    if (_reloadQueued && !isClosed) {
      _reloadQueued = false;
      await load();
    }
  }

  void applyFilter(CatalogFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  void resetFilter() {
    emit(state.copyWith(filter: const CatalogFilter()));
  }

  Product? productById(int id) {
    for (final product in state.products) {
      if (product.id == id) return product;
    }
    return null;
  }

  Future<void> _showCachedIfNeeded() async {
    if (state.products.isNotEmpty) return;
    emit(state.copyWith(status: CatalogStatus.loading, failure: () => null));
    final cached = await _repository.readCached();
    if (isClosed || cached.isEmpty) return;
    emit(state.copyWith(status: CatalogStatus.success, products: cached));
  }

  void _emitLoaded(List<Product> products) {
    final category = state.filter.category;
    final keepsCategory =
        category == null || products.any((p) => p.category == category);
    emit(
      state.copyWith(
        status: products.isEmpty ? CatalogStatus.empty : CatalogStatus.success,
        products: products,
        // Категория могла исчезнуть из каталога после обновления.
        filter: keepsCategory
            ? state.filter
            : CatalogFilter(
                minCents: state.filter.minCents,
                maxCents: state.filter.maxCents,
              ),
        failure: () => null,
        isRefreshing: false,
      ),
    );
  }

  void _emitFailure(AppFailure failure) {
    emit(
      state.copyWith(
        status: state.products.isNotEmpty
            ? CatalogStatus.success
            : CatalogStatus.error,
        failure: () => failure,
        isRefreshing: false,
      ),
    );
  }

  void _onOnlineChanged(bool online) {
    if (isClosed) return;
    final restored = online && !state.isOnline;
    emit(state.copyWith(isOnline: online));
    if (restored) unawaited(load());
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    return super.close();
  }
}
