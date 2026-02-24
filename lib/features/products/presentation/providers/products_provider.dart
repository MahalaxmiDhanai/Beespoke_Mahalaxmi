/// Riverpod provider for the product feed state.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/product.dart';
import 'di_providers.dart';

/// Async state of the product feed (loading / data / error).
final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);

/// Manages loading + like/dislike mutations for the product list.
class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() => _fetchProducts();

  Future<List<Product>> _fetchProducts() async {
    final result = await ref.read(getProductsUseCaseProvider).call();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (products) => products,
    );
  }

  /// Toggles the like state of the product with [id].
  Future<void> toggleLike(int id) async {
    final currentList = state.valueOrNull ?? [];
    final product = currentList.firstWhere((p) => p.id == id);
    final willLike = !product.isLiked;

    // Optimistic update
    state = AsyncData(
      currentList
          .map((p) => p.id == id ? p.copyWith(isLiked: willLike) : p)
          .toList(),
    );

    final result = willLike
        ? await ref.read(likeProductUseCaseProvider).call(id)
        : await ref.read(dislikeProductUseCaseProvider).call(id);

    // Revert on failure
    result.fold(
      (_) {
        state = AsyncData(
          currentList
              .map((p) => p.id == id ? p.copyWith(isLiked: !willLike) : p)
              .toList(),
        );
      },
      (_) {},
    );
  }

  /// Refreshes the product list from the remote API.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchProducts);
  }
}
