import 'package:injectable/injectable.dart' show injectable;

import '../locale_repository.dart';

/// Код выбранного языка или null, если используется язык системы.
@injectable
class GetSavedLanguage {
  const GetSavedLanguage(this._repository);

  final LocaleRepository _repository;

  Future<String?> call() => _repository.read();
}
