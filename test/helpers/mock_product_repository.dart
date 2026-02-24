// Mock ProductRepository helper for widget and unit tests.
import 'package:beespoke_app/core/errors/failures.dart';
import 'package:beespoke_app/features/products/domain/models/product.dart';
import 'package:beespoke_app/features/products/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

MockProductRepository setupSuccessRepo(List<Product> products) {
  final repo = MockProductRepository();
  when(() => repo.getProducts()).thenAnswer((_) async => Right(products));
  when(() => repo.likeProduct(any()))
      .thenAnswer((_) async => const Right(unit));
  when(() => repo.dislikeProduct(any()))
      .thenAnswer((_) async => const Right(unit));
  when(() => repo.getLikedProductIds()).thenReturn(const Right({}));
  return repo;
}

MockProductRepository setupFailureRepo() {
  final repo = MockProductRepository();
  when(() => repo.getProducts())
      .thenAnswer((_) async => const Left(NetworkFailure()));
  when(() => repo.getLikedProductIds()).thenReturn(const Right({}));
  return repo;
}
