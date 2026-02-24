/// Use case to dislike (unlike) a product.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/product_repository.dart';

/// Removes the like for the product with the given [id].
class DislikeProductUseCase {
  const DislikeProductUseCase(this._repository);

  final ProductRepository _repository;

  /// Executes the use case with the product [id].
  Future<Either<Failure, Unit>> call(int id) => _repository.dislikeProduct(id);
}
