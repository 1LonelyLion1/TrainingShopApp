import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/core/error/app_failure.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_api.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.handler);

  final ResponseBody Function(RequestOptions options) handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => handler(options);

  @override
  void close({bool force = false}) {}
}

CatalogApi _apiWith(ResponseBody Function(RequestOptions) handler) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = _Adapter(handler);
  return DioCatalogApi(dio);
}

CatalogApi _apiBody(String body, [int status = 200]) =>
    _apiWith((_) => ResponseBody.fromString(body, status));

CatalogApi _apiError(DioExceptionType type) => _apiWith(
  (options) => throw DioException(requestOptions: options, type: type),
);

void main() {
  test('разбирает товары и хранит цену в центах', () async {
    const body =
        '[{"id":1,"title":"A","price":109.95,"description":"D",'
        '"category":"c","image":"i","rating":{"rate":3.9,"count":120}}]';

    final products = await _apiBody(body).fetchProducts();

    expect(products.single.priceCents, 10995);
    expect(products.single.ratingCount, 120);
  });

  final cases = <String, (CatalogApi, Matcher)>{
    'нет сети': (
      _apiError(DioExceptionType.connectionError),
      isA<NoConnectionFailure>(),
    ),
    'таймаут': (
      _apiError(DioExceptionType.receiveTimeout),
      isA<TimeoutFailure>(),
    ),
    '5xx': (_apiBody('oops', 503), equals(const ServerFailure(503))),
    '4xx': (_apiBody('nope', 404), equals(const ClientFailure(404))),
    'пустое тело': (_apiBody('  '), isA<EmptyResponseFailure>()),
    'null в теле': (_apiBody('null'), isA<EmptyResponseFailure>()),
    'битый JSON': (_apiBody('{oops'), isA<InvalidDataFailure>()),
    'не список': (_apiBody('{"a":1}'), isA<InvalidDataFailure>()),
  };

  cases.forEach((name, testCase) {
    test('ошибка: $name', () async {
      await expectLater(testCase.$1.fetchProducts(), throwsA(testCase.$2));
    });
  });
}
