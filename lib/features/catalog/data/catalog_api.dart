import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart' show LazySingleton;

import '../../../core/error/app_failure.dart';
import '../../../core/network/dio_failure_mapper.dart';
import '../domain/product.dart';

abstract interface class CatalogApi {
  /// Бросает [AppFailure] при любой ошибке.
  Future<List<Product>> fetchProducts();
}

@LazySingleton(as: CatalogApi)
class DioCatalogApi implements CatalogApi {
  DioCatalogApi(this._dio);

  final Dio _dio;

  static Dio createDio() => Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  @override
  Future<List<Product>> fetchProducts() async {
    final String? body;
    try {
      // Тело разбирается вручную, чтобы отличить пустой ответ от битого JSON.
      final response = await _dio.get<String>(
        '/products',
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
      return (decoded as List)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
    } on AppFailure {
      rethrow;
    } on FormatException {
      throw const InvalidDataFailure();
    } on TypeError {
      throw const InvalidDataFailure();
    }
  }
}
