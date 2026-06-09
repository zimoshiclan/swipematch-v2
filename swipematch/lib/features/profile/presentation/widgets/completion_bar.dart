import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_styles.dart';

class CompletionBar extends StatelessWidget {
  const CompletionBar({super.key, required this.percent});

  final double percent; // 0.0 to 1.0

  @override
  Widget build(BuildContext context) {
    if (percent >= 1.0) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent.clamp(0.0, 1.0),
                backgroundColor: AppColors.card,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 6,
              ).animate().shimmer(duration: 1500.ms, delay: 800.ms),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${(percent * 100).round()}% profile',
            style: AppTextStyles.label.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
