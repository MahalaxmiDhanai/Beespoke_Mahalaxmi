/// Product card widget for the feed grid.
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../domain/models/product.dart';
import '../providers/products_provider.dart';
import 'like_button.dart';

/// Displays a single product in the feed grid.
///
/// Pure display widget; like toggle is dispatched through [ProductsNotifier].
class ProductCard extends ConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductImage(imageUrl: product.imageUrl),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                          ),
                          const Spacer(),
                          LikeButton(
                            isLiked: product.isLiked,
                            onToggle: () => ref
                                .read(productsProvider.notifier)
                                .toggleLike(product.id),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _RatingRow(
                        rating: product.rating,
                        count: product.ratingCount,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 150,
          width: double.infinity,
          fit: BoxFit.contain,
          placeholder: (_, __) => Container(
            height: 150,
            color: AppColors.shimmerBase,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            height: 150,
            color: AppColors.shimmerBase,
            child:
                const Icon(Icons.broken_image_outlined, color: Colors.white24),
          ),
        ),
      );
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating, required this.count});

  final double rating;
  final int count;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(Icons.star_rounded, size: 14, color: AppColors.starGold),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.starGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: const TextStyle(fontSize: 11, color: Colors.white38),
          ),
        ],
      );
}
