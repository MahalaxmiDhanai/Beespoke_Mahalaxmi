/// Abstract and concrete remote datasources for products.
library;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/errors/failures.dart';
import '../../dtos/product_dto.dart';

/// Contract for the remote product data source.
abstract interface class ProductRemoteDatasource {
  /// Fetches all products from the remote API.
  Future<Either<Failure, List<ProductDto>>> getProducts();
}

/// Dio-based implementation of [ProductRemoteDatasource].
class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  ProductRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Either<Failure, List<ProductDto>>> getProducts() async {
    try {
      final response = await _dio.get<dynamic>(kProductsPath);
      final body = response.data;
      if (body is! List) {
        return Left<Failure, List<ProductDto>>(
          ServerFailure('Unexpected API response format.'),
        );
      }
      final dtos = body
          .cast<Map<String, dynamic>>()
          .map(ProductDto.fromJson)
          .toList();
      return Right<Failure, List<ProductDto>>(dtos);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return Left<Failure, List<ProductDto>>(NetworkFailure());
      }
      final code = e.response?.statusCode;
      final msg = code != null ? 'Server error $code.' : 'Server error.';
      return Left<Failure, List<ProductDto>>(ServerFailure(msg));
    } catch (_) {
      return Left<Failure, List<ProductDto>>(ServerFailure());
    }
  }
}
