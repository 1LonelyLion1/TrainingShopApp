import 'package:equatable/equatable.dart';

/// Типизированная ошибка приложения. UI получает тип и сам выбирает
/// локализованное сообщение, ничего не зная о dio или кодах транспорта.
sealed class AppFailure extends Equatable implements Exception {
  const AppFailure();

  @override
  List<Object?> get props => const [];
}

final class NoConnectionFailure extends AppFailure {
  const NoConnectionFailure();
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure();
}

final class ServerFailure extends AppFailure {
  const ServerFailure(this.statusCode);

  final int statusCode;

  @override
  List<Object?> get props => [statusCode];
}

final class ClientFailure extends AppFailure {
  const ClientFailure(this.statusCode);

  final int statusCode;

  @override
  List<Object?> get props => [statusCode];
}

final class EmptyResponseFailure extends AppFailure {
  const EmptyResponseFailure();
}

final class InvalidDataFailure extends AppFailure {
  const InvalidDataFailure();
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure();
}
