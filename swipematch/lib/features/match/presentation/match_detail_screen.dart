import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/match_providers.dart';
import '../domain/match_reason_model.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';

class MatchDetailScreen extends HookConsumerWidget {
  const MatchDetailScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchDetailProvider(matchId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.canPop() ? context.pop() : null,
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary, size: 20),
        ),
        title: Text('Match Details', style: AppTextStyles.headlineSm),
      ),
      body: matchAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Failed to load match', style: AppTextStyles.bodyMd),
        ),
        data: (match) {
          if (match == null) {
            return Center(
              child: Text('Match not found', style: AppTextStyles.bodyMd),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CompanyHeader(
                  logoUrl: match.companyLogoUrl,
                  jobTitle: match.jobTitle,
                  companyName: match.companyName,
                  score: match.matchScore,
                ),
                const SizedBox(height: AppSpacing.xl),
                _BreakdownSection(reason: match.matchReason),
                const SizedBox(height: AppSpacing.lg),
                if (match.matchReason.coachingTip.isNotEmpty)
                  _CoachingTip(tip: match.matchReason.coachingTip),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Open Chat',
                  onPressed: () => context.push(AppRoutes.chatPath(matchId)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CompanyHeader extends StatelessWidget {
  const _CompanyHeader({
    required this.logoUrl,
    required this.jobTitle,
    required this.companyName,
    required this.score,
  });
  final String? logoUrl;
  final String? jobTitle;
  final String? companyName;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: logoUrl != null
                ? CachedNetworkImage(
                    imageUrl: logoUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => const _FallbackLogo(),
                  )
                : const _FallbackLogo(),
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
        const SizedBox(height: AppSpacing.md),
        Text(
          jobTitle ?? 'Position',
          style: AppTextStyles.headlineSm,
          textAlign: TextAlign.center,
        ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
        if (companyName != null) ...[
          const SizedBox(height: 4),
          Text(
            '@ $companyName',
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
          ).animate(delay: 150.ms).fadeIn(duration: 300.ms),
        ],
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: _scoreColor(score).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _scoreColor(score).withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            '$score% Match',
            style: AppTextStyles.headlineSm.copyWith(
              color: _scoreColor(score),
            ),
          ),
        ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
      ],
    );
  }

  Color _scoreColor(int s) {
    if (s >= 80) return AppColors.accent;
    if (s >= 60) return AppColors.matchGold;
    return AppColors.textSecondary;
  }
}

class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: const Icon(Icons.business_rounded,
          color: AppColors.primary, size: 32),
    );
  }
}

class _BreakdownSection extends StatelessWidget {
  const _BreakdownSection({required this.reason});
  final MatchReasonModel reason;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Score Breakdown', style: AppTextStyles.headlineSm),
        const SizedBox(height: AppSpacing.md),
        if (reason.matchSummary.isNotEmpty) ...[
          Text(reason.matchSummary, style: AppTextStyles.bodyMd),
          const SizedBox(height: AppSpacing.md),
        ],
        _DimRow('Skills', reason.skills, 50, AppColors.primary, 400.ms),
        _DimRow('Work Style', reason.workStyle, 30, AppColors.matchGold, 600.ms),
        _DimRow('Experience', reason.experience, 20, AppColors.superLike, 700.ms),
      ],
    ).animate(delay: 300.ms).fadeIn(duration: 400.ms);
  }
}

class _DimRow extends StatelessWidget {
  const _DimRow(
    this.label,
    this.dim,
    this.maxScore,
    this.color,
    this.delay,
  );

  final String label;
  final DimensionScore dim;
  final int maxScore;
  final Color color;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: AppTextStyles.bodyMd),
              const Spacer(),
              Text(
                '${dim.score}/$maxScore pts',
                style: AppTextStyles.label.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: dim.score / maxScore),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: AppColors.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                );
              },
            ),
          ),
          if (dim.reason.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              dim.reason,
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ).animate(delay: delay).fadeIn(duration: 300.ms).slideX(begin: 0.05),
    );
  }
}

class _CoachingTip extends StatelessWidget {
  const _CoachingTip({required this.tip});
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(tip, style: AppTextStyles.bodyMd),
          ),
        ],
      ),
    ).animate(delay: 800.ms).fadeIn(duration: 400.ms);
  }
}
