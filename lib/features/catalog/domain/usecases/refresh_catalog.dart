import 'package:injectable/injectable.dart' show injectable;

import '../catalog_repository.dart';
import '../product.dart';

/// Свежий каталог из сети. Бросает AppFailure.
@injectable
class RefreshCatalog {
  const RefreshCatalog(this._repository);

  final CatalogRepository _repository;

  Future<List<Product>> call() => _repository.refresh();
}
