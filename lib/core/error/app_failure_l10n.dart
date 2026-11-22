import '../../l10n/l10n.dart';
import 'app_failure.dart';

extension AppFailureL10n on AppFailure {
  String localized(AppLocalizations l10n) => switch (this) {
    NoConnectionFailure() => l10n.errorNoConnection,
    TimeoutFailure() => l10n.errorTimeout,
    ServerFailure(:final statusCode) => l10n.errorServer('$statusCode'),
    ClientFailure(:final statusCode) => l10n.errorClient('$statusCode'),
    EmptyResponseFailure() => l10n.errorEmptyResponse,
    InvalidDataFailure() => l10n.errorInvalidData,
    UnknownFailure() => l10n.errorUnknown,
  };
}
