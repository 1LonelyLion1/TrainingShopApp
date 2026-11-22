import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart' show LazySingleton;

import '../../../core/database/app_database.dart';
import '../domain/product.dart';

abstract interface class CatalogCache {
  Future<List<Product>> read();

  Future<void> write(List<Product> products);
}

@LazySingleton(as: CatalogCache)
class DriftCatalogCache implements CatalogCache {
  DriftCatalogCache(this._db);

  final AppDatabase _db;

  @override
  Future<List<Product>> read() async {
    try {
      final query = _db.select(_db.catalogProducts)
        ..orderBy([(table) => OrderingTerm.asc(table.position)]);
      final rows = await query.get();
      return rows.map(_toProduct).toList(growable: false);
    } on Object catch (error) {
      // Сбой чтения кеша не должен мешать загрузке из сети.
      debugPrint('Failed to read catalog cache: $error');
      return const [];
    }
  }

  /// Замена атомарна: при сбое останется предыдущая версия каталога.
  @override
  Future<void> write(List<Product> products) => _db.transaction(() async {
    await _db.delete(_db.catalogProducts).go();
    await _db.batch((batch) {
      batch.insertAll(_db.catalogProducts, [
        for (final (index, product) in products.indexed)
          CatalogProductsCompanion.insert(
            productId: Value(product.id),
            title: product.title,
            priceCents: product.priceCents,
            description: product.description,
            category: product.category,
            imageUrl: product.imageUrl,
            rating: product.rating,
            ratingCount: product.ratingCount,
            position: index,
          ),
      ], mode: InsertMode.insertOrReplace);
    });
  });

  Product _toProduct(CatalogProductRow row) => Product(
    id: row.productId,
    title: row.title,
    priceCents: row.priceCents,
    description: row.description,
    category: row.category,
    imageUrl: row.imageUrl,
    rating: row.rating,
    ratingCount: row.ratingCount,
  );
}
