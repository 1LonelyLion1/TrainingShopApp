import 'dart:math';

/// Локальный номер заказа вида HH-20261122-K7M2QX.
String generateOrderNumber({DateTime? now, Random? random}) {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final date = now ?? DateTime.now();
  final rng = random ?? Random.secure();
  final suffix = List.generate(
    6,
    (_) => alphabet[rng.nextInt(alphabet.length)],
  ).join();
  final day =
      '${date.year}'
      '${date.month.toString().padLeft(2, '0')}'
      '${date.day.toString().padLeft(2, '0')}';
  return 'HH-$day-$suffix';
}
