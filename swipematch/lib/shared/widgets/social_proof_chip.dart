import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SocialProofChip extends StatelessWidget {
  const SocialProofChip({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  factory SocialProofChip.applicants(int count) => SocialProofChip(
        label: '$count applied',
        icon: Icons.people_outline_rounded,
      );

  factory SocialProofChip.hot(int count) => SocialProofChip(
        label: '🔥 $count interested',
      );

  factory SocialProofChip.profileViews(int count) => SocialProofChip(
        label: '👁 Seen by $count employers',
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: AppColors.textSecondary),
            const SizedBox(width: 4),
          ],
          Text(label, style: AppTextStyles.label),
        ],
      ),
    );
  }
}
