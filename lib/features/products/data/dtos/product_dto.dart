/// ProductDto – JSON Data Transfer Object for FakeStoreAPI products.
///
/// Uses [freezed] for immutability and [json_serializable] for JSON parsing.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_dto.freezed.dart';
part 'product_dto.g.dart';

/// DTO for a product returned by `GET /products`.
@freezed
class ProductDto with _$ProductDto {
  const factory ProductDto({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
    required RatingDto rating,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);
}

/// DTO for the nested rating object.
@freezed
class RatingDto with _$RatingDto {
  const factory RatingDto({
    required double rate,
    required int count,
  }) = _RatingDto;

  factory RatingDto.fromJson(Map<String, dynamic> json) =>
      _$RatingDtoFromJson(json);
}
