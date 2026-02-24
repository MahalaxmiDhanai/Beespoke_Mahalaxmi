/// Shared skeleton loading card for product feed.
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Animated shimmer placeholder shown while products are loading.
class SkeletonCard extends StatefulWidget {
  const SkeletonCard({super.key});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Opacity(
          opacity: _animation.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerLine(width: double.infinity),
                    const SizedBox(height: 6),
                    _shimmerLine(width: 120),
                    const SizedBox(height: 8),
                    _shimmerLine(width: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _shimmerLine({required double width}) => Container(
        width: width,
        height: 12,
        decoration: BoxDecoration(
          color: AppColors.shimmerHighlight,
          borderRadius: BorderRadius.circular(6),
        ),
      );
}
