import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';
import '../domain/usecases/save_language.dart';

/// Состояние — выбранный язык; null означает язык системы.
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit(this._saveLanguage, [super.initial]);

  final SaveLanguage _saveLanguage;
  Future<void> _lastWrite = Future.value();

  /// Неизвестный код из хранилища сводится к языку системы.
  static Locale? parse(String? languageCode) {
    for (final locale in AppLocalizations.supportedLocales) {
      if (locale.languageCode == languageCode) return locale;
    }
    return null;
  }

  Future<void> select(Locale? locale) {
    if (locale == state) return _lastWrite;
    emit(locale);
    return _lastWrite = _lastWrite.then((_) async {
      try {
        await _saveLanguage(locale?.languageCode);
      } on Object catch (error) {
        debugPrint('Failed to save locale: $error');
      }
    });
  }
}
