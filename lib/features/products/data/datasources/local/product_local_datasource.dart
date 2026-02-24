/// Local Hive datasource for persisting liked product IDs.
library;

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/constants/app_constants.dart';

/// Contract for the local likes datasource.
abstract interface class ProductLocalDatasource {
  /// Returns a set of liked product IDs.
  Set<int> getLikedIds();

  /// Marks a product as liked.
  Future<void> likeProduct(int id);

  /// Removes a product from liked list.
  Future<void> dislikeProduct(int id);
}

/// Hive-backed implementation of [ProductLocalDatasource].
class ProductLocalDatasourceImpl implements ProductLocalDatasource {
  ProductLocalDatasourceImpl(this._box);

  final Box<int> _box;

  /// Opens the Hive box. Call before using the datasource.
  static Future<ProductLocalDatasourceImpl> open() async {
    final box = await Hive.openBox<int>(kLikesBoxName);
    return ProductLocalDatasourceImpl(box);
  }

  @override
  Set<int> getLikedIds() => _box.values.toSet();

  @override
  Future<void> likeProduct(int id) async {
    await _box.put(id.toString(), id);
  }

  @override
  Future<void> dislikeProduct(int id) async {
    await _box.delete(id.toString());
  }
}
