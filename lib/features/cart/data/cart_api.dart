import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart' show LazySingleton;

import '../../../core/error/app_failure.dart';
import '../../../core/network/dio_failure_mapper.dart';

class CartLine extends Equatable {
  const CartLine({required this.productId, required this.quantity});

  final int productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];
}

abstract interface class CartApi {
  /// Бросает [AppFailure] при любой ошибке.
  Future<List<CartLine>> fetchCart(int cartId);

  /// Бросает [AppFailure] при любой ошибке.
  Future<void> updateCart(int cartId, List<CartLine> lines);
}

@LazySingleton(as: CartApi)
class DioCartApi implements CartApi {
  DioCartApi(this._dio);

  /// В приложении нет авторизации, поэтому используется демо-пользователь.
  static const demoUserId = 1;

  final Dio _dio;

  @override
  Future<List<CartLine>> fetchCart(int cartId) async {
    final String? body;
    try {
      final response = await _dio.get<String>(
        '/carts/$cartId',
        options: Options(responseType: ResponseType.plain),
      );
      body = response.data;
    } on DioException catch (error) {
      throw mapDioException(error);
    }

    if (body == null || body.trim().isEmpty) {
      throw const EmptyResponseFailure();
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded == null) throw const EmptyResponseFailure();
      final products = (decoded as Map<String, dynamic>)['products'] as List;
      return products
          .map((item) {
            final line = item as Map<String, dynamic>;
            return CartLine(
              productId: (line['productId'] as num).toInt(),
              quantity: (line['quantity'] as num).toInt(),
            );
          })
          .toList(growable: false);
    } on AppFailure {
      rethrow;
    } on FormatException {
      throw const InvalidDataFailure();
    } on TypeError {
      throw const InvalidDataFailure();
    }
  }

  @override
  Future<void> updateCart(int cartId, List<CartLine> lines) async {
    try {
      await _dio.put<String>(
        '/carts/$cartId',
        data: {
          'id': cartId,
          'userId': demoUserId,
          'products': [
            for (final line in lines)
              {'productId': line.productId, 'quantity': line.quantity},
          ],
        },
        options: Options(responseType: ResponseType.plain),
      );
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }
}
