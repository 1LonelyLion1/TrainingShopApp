import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart' show lazySingleton;

import '../../../core/error/app_failure.dart';
import '../domain/product.dart';
import 'catalog_api.dart';
import 'catalog_cache.dart';

@lazySingleton
class CatalogRepository {
  CatalogRepository({required this._api, required this._cache});

  final CatalogApi _api;
  final CatalogCache _cache;

  Future<List<Product>> readCached() => _cache.read();

  /// Загружает каталог и обновляет кеш. Бросает [AppFailure].
  ///
  /// Пустой список в кеш не пишется: иначе единичный сбой API
  /// стёр бы последние товары, доступные офлайн.
  Future<List<Product>> refresh() async {
    final List<Product> products;
    try {
      products = await _api.fetchProducts();
    } on AppFailure {
      rethrow;
    } on Object {
      throw const UnknownFailure();
    }

    if (products.isNotEmpty) {
      try {
        await _cache.write(products);
      } on Object catch (error) {
        // Свежие данные важнее: сбой записи не должен скрывать каталог.
        debugPrint('Failed to save catalog: $error');
      }
    }
    return products;
  }
}
