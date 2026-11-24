import 'package:injectable/injectable.dart' show injectable;

import '../catalog_repository.dart';
import '../product.dart';

/// Каталог из кеша: показывается сразу, пока идёт загрузка из сети.
@injectable
class GetCachedCatalog {
  const GetCachedCatalog(this._repository);

  final CatalogRepository _repository;

  Future<List<Product>> call() => _repository.readCached();
}
