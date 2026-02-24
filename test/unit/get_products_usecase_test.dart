// Unit tests for GetProductsUseCase.
import 'package:beespoke_app/core/errors/failures.dart';
import 'package:beespoke_app/features/products/domain/models/product.dart';
import 'package:beespoke_app/features/products/domain/repositories/product_repository.dart';
import 'package:beespoke_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

const _testProduct = Product(
  id: 1,
  title: 'Product',
  price: 9.99,
  description: 'D',
  category: 'C',
  imageUrl: 'img',
  rating: 4.0,
  ratingCount: 10,
);

void main() {
  late MockProductRepository repo;
  late GetProductsUseCase useCase;

  setUp(() {
    repo = MockProductRepository();
    useCase = GetProductsUseCase(repo);
  });

  test('returns product list on repository success', () async {
    when(() => repo.getProducts()).thenAnswer(
      (_) async => const Right<Failure, List<Product>>([_testProduct]),
    );

    final result = await useCase();

    expect(result.isRight(), isTrue);
    result.fold((_) {}, (products) => expect(products, [_testProduct]));
  });

  test('propagates failure from repository', () async {
    when(() => repo.getProducts()).thenAnswer(
      (_) async => Left<Failure, List<Product>>(const NetworkFailure()),
    );

    final result = await useCase();

    expect(result.isLeft(), isTrue);
  });
}
