import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart' show LazySingleton;

import '../../../core/database/app_database.dart';

abstract interface class LocaleStorage {
  /// Код языка или null, если используется язык системы.
  Future<String?> read();

  Future<void> write(String? languageCode);
}

@LazySingleton(as: LocaleStorage)
class DriftLocaleStorage implements LocaleStorage {
  DriftLocaleStorage(this._db);

  static const _key = 'locale';

  final AppDatabase _db;

  @override
  Future<String?> read() async {
    try {
      final query = _db.select(_db.appSettings)
        ..where((table) => table.settingKey.equals(_key));
      return (await query.getSingleOrNull())?.settingValue;
    } on Object catch (error) {
      debugPrint('Failed to read locale: $error');
      return null;
    }
  }

  @override
  Future<void> write(String? languageCode) async {
    if (languageCode == null) {
      await (_db.delete(
        _db.appSettings,
      )..where((table) => table.settingKey.equals(_key))).go();
      return;
    }
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            settingKey: _key,
            settingValue: languageCode,
          ),
        );
  }
}
