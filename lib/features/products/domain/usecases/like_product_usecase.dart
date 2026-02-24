/// Use case to like a product.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/product_repository.dart';

/// Persists a like for the product with the given [id].
class LikeProductUseCase {
  const LikeProductUseCase(this._repository);

  final ProductRepository _repository;

  /// Executes the use case with the product [id].
  Future<Either<Failure, Unit>> call(int id) => _repository.likeProduct(id);
}
