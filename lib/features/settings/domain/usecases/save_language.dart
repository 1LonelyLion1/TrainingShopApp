import 'package:injectable/injectable.dart' show injectable;

import '../locale_repository.dart';

/// null возвращает язык системы.
@injectable
class SaveLanguage {
  const SaveLanguage(this._repository);

  final LocaleRepository _repository;

  Future<void> call(String? languageCode) => _repository.write(languageCode);
}
