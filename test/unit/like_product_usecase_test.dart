// Unit tests for LikeProductUseCase and DislikeProductUseCase.
import 'package:beespoke_app/core/errors/failures.dart';
import 'package:beespoke_app/features/products/domain/repositories/product_repository.dart';
import 'package:beespoke_app/features/products/domain/usecases/dislike_product_usecase.dart';
import 'package:beespoke_app/features/products/domain/usecases/like_product_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository repo;
  late LikeProductUseCase likeUC;
  late DislikeProductUseCase dislikeUC;

  setUp(() {
    repo = MockProductRepository();
    likeUC = LikeProductUseCase(repo);
    dislikeUC = DislikeProductUseCase(repo);
  });

  group('LikeProductUseCase', () {
    test('calls repository.likeProduct with correct id', () async {
      when(() => repo.likeProduct(42))
          .thenAnswer((_) async => Right<Failure, Unit>(unit));

      final result = await likeUC(42);

      verify(() => repo.likeProduct(42)).called(1);
      expect(result.isRight(), isTrue);
    });

    test('returns CacheFailure when repo fails', () async {
      when(() => repo.likeProduct(1))
          .thenAnswer((_) async => Left<Failure, Unit>(const CacheFailure()));

      final result = await likeUC(1);
      expect(result.isLeft(), isTrue);
    });
  });

  group('DislikeProductUseCase', () {
    test('calls repository.dislikeProduct with correct id', () async {
      when(() => repo.dislikeProduct(5))
          .thenAnswer((_) async => Right<Failure, Unit>(unit));

      final result = await dislikeUC(5);

      verify(() => repo.dislikeProduct(5)).called(1);
      expect(result.isRight(), isTrue);
    });
  });
}
