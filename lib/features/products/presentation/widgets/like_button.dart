/// Animated like/dislike button with heart scale animation.
library;

import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';

/// A heart icon button that animates when tapped.
///
/// Shows filled red heart when [isLiked], outline heart otherwise.
class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.isLiked,
    required this.onToggle,
  });

  final bool isLiked;
  final VoidCallback onToggle;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1, end: 1.35).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _handleTap,
        child: ScaleTransition(
          scale: _scale,
          child: Icon(
            widget.isLiked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: widget.isLiked ? AppColors.likeRed : Colors.white54,
            size: 26,
          ),
        ),
      );
}
