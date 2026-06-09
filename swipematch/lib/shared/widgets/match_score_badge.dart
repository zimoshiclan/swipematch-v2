import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class MatchScoreBadge extends StatelessWidget {
  const MatchScoreBadge({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$score%',
        style: AppTextStyles.label.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color get _backgroundColor {
    if (score >= 80) return AppColors.accent.withValues(alpha: 0.2);
    if (score >= 60) return AppColors.matchGold.withValues(alpha: 0.2);
    return AppColors.surface;
  }

  Color get _textColor {
    if (score >= 80) return AppColors.accent;
    if (score >= 60) return AppColors.matchGold;
    return AppColors.textSecondary;
  }
}
