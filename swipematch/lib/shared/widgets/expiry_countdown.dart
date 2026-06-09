import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/date_utils.dart';
import '../constants/app_constants.dart';

class ExpiryCountdown extends StatefulWidget {
  const ExpiryCountdown({super.key, required this.createdAt});

  final DateTime createdAt;

  @override
  State<ExpiryCountdown> createState() => _ExpiryCountdownState();
}

class _ExpiryCountdownState extends State<ExpiryCountdown> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = AppDateUtils.untilCardExpiry(widget.createdAt);
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {
          _remaining = AppDateUtils.untilCardExpiry(widget.createdAt);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool get _isExpiringSoon =>
      _remaining.inHours < AppConstants.expiryWarningHours;

  @override
  Widget build(BuildContext context) {
    if (_remaining == Duration.zero) return const SizedBox.shrink();
    if (!_isExpiringSoon) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, size: 11, color: AppColors.danger),
          const SizedBox(width: 3),
          Text(
            AppDateUtils.formatCountdown(_remaining),
            style: AppTextStyles.label.copyWith(color: AppColors.danger),
          ),
        ],
      ),
    );
  }
}
