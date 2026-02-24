/// Domain model for a product.
///
/// Pure Dart immutable class with no framework dependencies.
/// Uses [freezed] for immutability and value equality.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

/// Immutable domain model for a product.
@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String imageUrl,
    required double rating,
    required int ratingCount,
    @Default(false) bool isLiked,
  }) = _Product;
}
