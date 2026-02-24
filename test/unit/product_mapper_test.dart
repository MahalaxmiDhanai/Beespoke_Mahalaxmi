// Unit tests for ProductMapper.
import 'package:beespoke_app/features/products/data/dtos/product_dto.dart';
import 'package:beespoke_app/features/products/data/mappers/product_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductMapper', () {
    const dto = ProductDto(
      id: 1,
      title: 'Test Product',
      price: 19.99,
      description: 'A great product',
      category: 'electronics',
      image: 'https://example.com/img.jpg',
      rating: RatingDto(rate: 4.2, count: 320),
    );

    test('toModel maps all fields correctly', () {
      final model = ProductMapper.toModel(dto);

      expect(model.id, 1);
      expect(model.title, 'Test Product');
      expect(model.price, 19.99);
      expect(model.description, 'A great product');
      expect(model.category, 'electronics');
      expect(model.imageUrl, 'https://example.com/img.jpg');
      expect(model.rating, 4.2);
      expect(model.ratingCount, 320);
      expect(model.isLiked, false);
    });

    test('toModel sets isLiked to true when id is in likedIds', () {
      final model = ProductMapper.toModel(dto, isLiked: true);
      expect(model.isLiked, isTrue);
    });

    test('toModelList maps correctly and stamps isLiked from set', () {
      const dto2 = ProductDto(
        id: 2,
        title: 'Other',
        price: 9.99,
        description: 'Desc',
        category: 'clothing',
        image: 'https://example.com/img2.jpg',
        rating: RatingDto(rate: 3.5, count: 50),
      );

      final models = ProductMapper.toModelList(
        [dto, dto2],
        likedIds: {2},
      );

      expect(models[0].isLiked, isFalse);
      expect(models[1].isLiked, isTrue);
    });
  });
}
