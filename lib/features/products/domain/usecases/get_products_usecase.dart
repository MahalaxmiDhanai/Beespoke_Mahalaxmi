/// Use case to fetch all products.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

/// Fetches the full list of products from the repository.
///
/// Single Responsibility: delegates entirely to [ProductRepository].
class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  /// Executes the use case.
  Future<Either<Failure, List<Product>>> call() => _repository.getProducts();
}
