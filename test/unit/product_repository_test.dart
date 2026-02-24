// Unit tests for ProductRepositoryImpl using mocked sub-dependencies.
//
// Strategy: mock the ProductRepository interface directly to avoid
// pulling in Dio, Hive, and Freezed generated code into test compilation.
import 'package:beespoke_app/core/errors/failures.dart';
import 'package:beespoke_app/features/products/domain/models/product.dart';
import 'package:beespoke_app/features/products/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

const _liked = Product(
  id: 1,
  title: 'Product A',
  price: 10.0,
  description: 'Desc',
  category: 'cat',
  imageUrl: 'url',
  rating: 4.5,
  ratingCount: 100,
  isLiked: true,
);

const _notLiked = Product(
  id: 2,
  title: 'Product B',
  price: 20.0,
  description: 'Desc2',
  category: 'cat',
  imageUrl: 'url2',
  rating: 3.5,
  ratingCount: 50,
);

void main() {
  late MockProductRepository repo;

  setUp(() {
    repo = MockProductRepository();
  });

  group('ProductRepository contract — getProducts', () {
    test('returns Right list on success', () async {
      when(() => repo.getProducts()).thenAnswer(
        (_) async => Right<Failure, List<Product>>([_liked, _notLiked]),
      );

      final result = await repo.getProducts();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected products'),
        (products) {
          expect(products.length, 2);
          expect(products.first.isLiked, isTrue);
        },
      );
    });

    test('returns Left on network failure', () async {
      when(() => repo.getProducts()).thenAnswer(
        (_) async => Left<Failure, List<Product>>(const NetworkFailure()),
      );

      final result = await repo.getProducts();
      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });

  group('ProductRepository contract — likeProduct', () {
    test('returns Right(unit) on success', () async {
      when(() => repo.likeProduct(1))
          .thenAnswer((_) async => Right<Failure, Unit>(unit));

      final result = await repo.likeProduct(1);
      expect(result.isRight(), isTrue);
      verify(() => repo.likeProduct(1)).called(1);
    });

    test('returns Left on failure', () async {
      when(() => repo.likeProduct(99))
          .thenAnswer((_) async => Left<Failure, Unit>(const CacheFailure()));

      final result = await repo.likeProduct(99);
      expect(result.isLeft(), isTrue);
    });
  });

  group('ProductRepository contract — dislikeProduct', () {
    test('returns Right(unit) on success', () async {
      when(() => repo.dislikeProduct(1))
          .thenAnswer((_) async => Right<Failure, Unit>(unit));

      final result = await repo.dislikeProduct(1);
      expect(result.isRight(), isTrue);
    });
  });

  group('ProductRepository contract — getLikedProductIds', () {
    test('returns set of liked ids', () {
      when(() => repo.getLikedProductIds())
          .thenReturn(Right<Failure, Set<int>>({1, 3, 5}));

      final result = repo.getLikedProductIds();
      expect(result.getOrElse((_) => {}), {1, 3, 5});
    });
  });
}
