import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/haptics.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed == null
          ? null
          : () {
              AppHaptics.buttonTap();
              onPressed!();
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.textPrimary,
              ),
            )
          : Text(label, style: AppTextStyles.buttonText),
    ).animate(target: onPressed != null ? 1 : 0).scaleXY(
          begin: 1,
          end: 0.97,
          duration: 80.ms,
          curve: Curves.easeIn,
        );
  }
}
