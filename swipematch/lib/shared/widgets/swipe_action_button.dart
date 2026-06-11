import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum SwipeAction { left, right, superLike }

class SwipeActionButton extends StatelessWidget {
  const SwipeActionButton({
    super.key,
    this.action,
    this.icon,
    this.color,
    required this.onTap,
    this.size = 56,
  }) : assert(action != null || (icon != null && color != null),
            'Provide either an action or an icon+color override');

  final SwipeAction? action;
  final IconData? icon;
  final Color? color;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.card,
          border: Border.all(color: _color, width: 2),
        ),
        child: Icon(_icon, color: _color, size: size * 0.45),
      ),
    );
  }

  Color get _color =>
      color ??
      switch (action!) {
        SwipeAction.left => AppColors.danger,
        SwipeAction.right => AppColors.accent,
        SwipeAction.superLike => AppColors.superLike,
      };

  IconData get _icon =>
      icon ??
      switch (action!) {
        SwipeAction.left => Icons.close_rounded,
        SwipeAction.right => Icons.favorite_rounded,
        SwipeAction.superLike => Icons.bolt_rounded,
      };
}
