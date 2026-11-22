import 'package:dio/dio.dart';

import '../error/app_failure.dart';

AppFailure mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NoConnectionFailure();
    case DioExceptionType.badResponse:
      final status = error.response?.statusCode ?? 0;
      if (status >= 500) return ServerFailure(status);
      if (status >= 400) return ClientFailure(status);
      return const UnknownFailure();
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return const UnknownFailure();
  }
}
