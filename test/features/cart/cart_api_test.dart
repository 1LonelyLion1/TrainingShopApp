import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/core/error/app_failure.dart';
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_api.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.handler);

  final ResponseBody Function(RequestOptions options) handler;
  RequestOptions? last;
  String? lastBody;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    last = options;
    if (requestStream != null) {
      final bytes = await requestStream.expand((chunk) => chunk).toList();
      lastBody = utf8.decode(bytes);
    }
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

(DioCartApi, _Adapter) _api(ResponseBody Function(RequestOptions) handler) {
  final adapter = _Adapter(handler);
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = adapter;
  return (DioCartApi(dio), adapter);
}

ResponseBody _body(String body, [int status = 200]) =>
    ResponseBody.fromString(body, status);

void main() {
  test('разбирает корзину', () async {
    final (api, adapter) = _api(
      (_) => _body(
        '{"id":1,"userId":1,"products":'
        '[{"productId":3,"quantity":6},{"productId":1,"quantity":4}]}',
      ),
    );

    final lines = await api.fetchCart(1);

    expect(adapter.last?.path, '/carts/1');
    expect(lines, const [
      CartLine(productId: 3, quantity: 6),
      CartLine(productId: 1, quantity: 4),
    ]);
  });

  test('PUT отправляет позиции корзины', () async {
    final (api, adapter) = _api((_) => _body('{"id":1}'));

    await api.updateCart(1, const [CartLine(productId: 2, quantity: 5)]);

    expect(adapter.last?.method, 'PUT');
    expect(adapter.last?.path, '/carts/1');
    expect(jsonDecode(adapter.lastBody!), {
      'id': 1,
      'userId': 1,
      'products': [
        {'productId': 2, 'quantity': 5},
      ],
    });
  });

  final failures = <String, (String, int, Matcher)>{
    'несуществующая корзина': ('null', 200, isA<EmptyResponseFailure>()),
    'пустое тело': ('  ', 200, isA<EmptyResponseFailure>()),
    'битый JSON': ('{oops', 200, isA<InvalidDataFailure>()),
    'не объект': ('[1]', 200, isA<InvalidDataFailure>()),
    '5xx': ('oops', 503, equals(const ServerFailure(503))),
    '4xx': ('nope', 404, equals(const ClientFailure(404))),
  };

  failures.forEach((name, data) {
    test('чтение: $name', () async {
      final (api, _) = _api((_) => _body(data.$1, data.$2));

      await expectLater(api.fetchCart(1), throwsA(data.$3));
    });
  });

  test('запись: ошибка сервера типизируется', () async {
    final (api, _) = _api((_) => _body('oops', 500));

    await expectLater(
      api.updateCart(1, const []),
      throwsA(equals(const ServerFailure(500))),
    );
  });

  test('запись: нет сети', () async {
    final (api, _) = _api(
      (options) => throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      ),
    );

    await expectLater(
      api.updateCart(1, const []),
      throwsA(isA<NoConnectionFailure>()),
    );
  });
}
