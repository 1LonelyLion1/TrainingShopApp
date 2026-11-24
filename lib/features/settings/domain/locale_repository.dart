abstract interface class LocaleRepository {
  /// Код языка или null, если используется язык системы.
  Future<String?> read();

  Future<void> write(String? languageCode);
}
