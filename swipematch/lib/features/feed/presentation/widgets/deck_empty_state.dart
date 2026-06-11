import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_styles.dart';

class DeckEmptyState extends StatelessWidget {
  const DeckEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: 40,
              ),
            )
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppConstants.deckEmptyTitle,
              style: AppTextStyles.headlineSm,
              textAlign: TextAlign.center,
            ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppConstants.deckEmptySubtitle,
              style: AppTextStyles.bodyMd,
              textAlign: TextAlign.center,
            ).animate(delay: 150.ms).fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '⏰ New deck in ${_nextDeckCountdown()}',
              style:
                  AppTextStyles.bodyMd.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.xl),
            const _MissedMatchesCard()
                .animate(delay: 300.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }

  String _nextDeckCountdown() {
    final now = DateTime.now();
    final todayAt8 = DateTime(now.year, now.month, now.day, AppConstants.deckRefreshHour);
    final nextAt8 = now.isBefore(todayAt8)
        ? todayAt8
        : todayAt8.add(const Duration(days: 1));
    final diff = nextAt8.difference(now);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
}

class _MissedMatchesCard extends StatelessWidget {
  const _MissedMatchesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insights_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Last week',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppConstants.missedMatchesMessage,
            style: AppTextStyles.bodyMd,
          ),
        ],
      ),
    );
  }
}
