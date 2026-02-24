/// Mapper to convert [ProductDto] to [Product] domain model.
///
/// Single responsibility: field mapping only — no business logic.
library;

import '../../domain/models/product.dart';
import '../dtos/product_dto.dart';

/// Maps between [ProductDto] and [Product].
class ProductMapper {
  const ProductMapper._();

  /// Converts a [ProductDto] to a [Product] domain model.
  ///
  /// The [isLiked] flag is applied from local storage, defaulting to [false].
  static Product toModel(ProductDto dto, {bool isLiked = false}) => Product(
        id: dto.id,
        title: dto.title,
        price: dto.price,
        description: dto.description,
        category: dto.category,
        imageUrl: dto.image,
        rating: dto.rating.rate,
        ratingCount: dto.rating.count,
        isLiked: isLiked,
      );

  /// Converts a list of [ProductDto]s to [Product] domain models.
  static List<Product> toModelList(
    List<ProductDto> dtos, {
    Set<int> likedIds = const {},
  }) =>
      dtos
          .map((dto) => toModel(dto, isLiked: likedIds.contains(dto.id)))
          .toList();
}
