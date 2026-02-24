/// Concrete implementation of [ProductRepository].
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/models/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local/product_local_datasource.dart';
import '../datasources/remote/product_remote_datasource.dart';
import '../mappers/product_mapper.dart';

/// Combines remote and local datasources to fulfil the [ProductRepository] contract.
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required this.remote,
    required this.local,
  });

  final ProductRemoteDatasource remote;
  final ProductLocalDatasource local;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    final result = await remote.getProducts();
    return result.map((dtos) {
      final likedIds = local.getLikedIds();
      return ProductMapper.toModelList(dtos, likedIds: likedIds);
    });
  }

  @override
  Future<Either<Failure, Unit>> likeProduct(int id) async {
    try {
      await local.likeProduct(id);
      return Right<Failure, Unit>(unit);
    } catch (_) {
      return Left<Failure, Unit>(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> dislikeProduct(int id) async {
    try {
      await local.dislikeProduct(id);
      return Right<Failure, Unit>(unit);
    } catch (_) {
      return Left<Failure, Unit>(CacheFailure());
    }
  }

  @override
  Either<Failure, Set<int>> getLikedProductIds() {
    try {
      return Right<Failure, Set<int>>(local.getLikedIds());
    } catch (_) {
      return Left<Failure, Set<int>>(CacheFailure());
    }
  }
}
