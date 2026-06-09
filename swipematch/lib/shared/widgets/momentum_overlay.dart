import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

class MomentumOverlay extends StatelessWidget {
  const MomentumOverlay({super.key, required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Center(
      child: Text(
        AppConstants.momentumMessage,
        style: AppTextStyles.headlineLg.copyWith(color: AppColors.accent),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.1, 1.1), duration: 300.ms)
          .then()
          .scale(begin: const Offset(1.1, 1.1), end: const Offset(1.0, 1.0), duration: 150.ms)
          .then(delay: 1200.ms)
          .fadeOut(duration: 400.ms),
    );
  }
}
