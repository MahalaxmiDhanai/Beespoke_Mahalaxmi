/// Abstract repository interface for products.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../models/product.dart';

/// Contract for the product repository.
///
/// Depends on abstractions, not concretions (Dependency Inversion Principle).
abstract interface class ProductRepository {
  /// Fetches all products, merging remote data with local like state.
  Future<Either<Failure, List<Product>>> getProducts();

  /// Likes a product by [id], persisting to local storage.
  Future<Either<Failure, Unit>> likeProduct(int id);

  /// Dislikes (unlikes) a product by [id].
  Future<Either<Failure, Unit>> dislikeProduct(int id);

  /// Returns the set of liked product IDs from local storage.
  Either<Failure, Set<int>> getLikedProductIds();
}
