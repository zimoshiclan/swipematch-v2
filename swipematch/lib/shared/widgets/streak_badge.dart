import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🔥', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
