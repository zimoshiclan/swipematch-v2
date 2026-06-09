import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class SkillTag extends StatelessWidget {
  const SkillTag({super.key, required this.label, this.highlighted = false});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.primary.withValues(alpha: 0.2)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: highlighted
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.5))
            : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: highlighted ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
