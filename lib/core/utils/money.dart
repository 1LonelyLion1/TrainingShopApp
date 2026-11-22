/// Деньги хранятся в центах, чтобы сумма не накапливала ошибку double.
String formatCents(int cents) {
  final dollars = cents ~/ 100;
  final remainder = (cents % 100).toString().padLeft(2, '0');
  return '\$$dollars.$remainder';
}

/// Разбирает ввод пользователя («12», «12.5», «12,50») в центы.
/// Возвращает null, если строка не является неотрицательной суммой.
int? parseCents(String input) {
  final normalized = input.trim().replaceAll(',', '.');
  final match = RegExp(r'^(\d{1,9})(?:\.(\d{0,2}))?$').firstMatch(normalized);
  if (match == null) return null;
  final whole = int.parse(match.group(1)!);
  final fraction = (match.group(2) ?? '').padRight(2, '0');
  return whole * 100 + int.parse(fraction);
}
