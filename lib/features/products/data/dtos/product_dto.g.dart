// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductDtoImpl _$$ProductDtoImplFromJson(Map<String, dynamic> json) =>
    _$ProductDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: RatingDto.fromJson(json['rating'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProductDtoImplToJson(_$ProductDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'description': instance.description,
      'category': instance.category,
      'image': instance.image,
      'rating': instance.rating,
    };

_$RatingDtoImpl _$$RatingDtoImplFromJson(Map<String, dynamic> json) =>
    _$RatingDtoImpl(
      rate: (json['rate'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$RatingDtoImplToJson(_$RatingDtoImpl instance) =>
    <String, dynamic>{
      'rate': instance.rate,
      'count': instance.count,
    };
