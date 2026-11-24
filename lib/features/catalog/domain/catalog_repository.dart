import 'product.dart';

abstract interface class CatalogRepository {
  /// Последний сохранённый каталог или пустой список.
  Future<List<Product>> readCached();

  /// Загружает каталог из сети и обновляет кеш. Бросает AppFailure.
  Future<List<Product>> refresh();
}
