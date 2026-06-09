import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/match_model.dart';
import '../domain/match_providers.dart';
import '../domain/match_reason_model.dart';
import '../../../router/app_router.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';

class MatchRevealScreen extends HookConsumerWidget {
  const MatchRevealScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchDetailProvider(matchId));

    useEffect(() {
      HapticFeedback.heavyImpact();
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: matchAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => _buildError(context),
        data: (match) => match == null
            ? _buildError(context)
            : _RevealContent(match: match),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.danger, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text('Match not found', style: AppTextStyles.headlineSm),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.go(AppRoutes.feed),
            child: Text('Back to feed',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _RevealContent extends HookWidget {
  const _RevealContent({required this.match});
  final MatchModel match;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _BackgroundGlow(),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                _CloseButton(),
                const SizedBox(height: AppSpacing.lg),
                _ConfettiParticles(),
                _CompanyLogo(logoUrl: match.companyLogoUrl),
                const SizedBox(height: AppSpacing.lg),
                _MatchHeadline(),
                const SizedBox(height: AppSpacing.sm),
                _JobTitle(title: match.jobTitle, company: match.companyName),
                const SizedBox(height: AppSpacing.xl),
                _ScoreCircle(score: match.matchScore),
                const SizedBox(height: AppSpacing.xl),
                _ScoreBreakdown(reason: match.matchReason),
                const SizedBox(height: AppSpacing.lg),
                _CoachingTip(tip: match.matchReason.coachingTip),
                const SizedBox(height: AppSpacing.xl),
                _ActionButtons(matchId: match.id),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              AppColors.primary.withValues(alpha: 0.15),
              AppColors.background,
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => context.canPop() ? context.pop() : context.go(AppRoutes.feed),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.close_rounded,
              color: AppColors.textSecondary, size: 20),
        ),
      ),
    );
  }
}

class _ConfettiParticles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.matchGold,
      AppColors.superLike,
      AppColors.hotBadge,
    ];

    return SizedBox(
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(20, (i) {
          final color = colors[i % colors.length];
          final dx = (i - 10) * 16.0;
          final dy = (i % 3 == 0) ? -20.0 : (i % 3 == 1) ? 0.0 : 20.0;
          return Transform.translate(
            offset: Offset(dx, dy),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: i % 2 == 0 ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: i % 2 != 0 ? BorderRadius.circular(2) : null,
              ),
            )
                .animate(delay: Duration(milliseconds: i * 40))
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                )
                .moveY(begin: 20, end: 0, duration: 500.ms, curve: Curves.easeOut),
          );
        }),
      ),
    );
  }
}

class _CompanyLogo extends StatelessWidget {
  const _CompanyLogo({required this.logoUrl});
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 2),
      ),
      child: ClipOval(
        child: logoUrl != null
            ? CachedNetworkImage(
                imageUrl: logoUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const _LogoFallback(),
              )
            : const _LogoFallback(),
      ),
    )
        .animate(delay: 100.ms)
        .scale(begin: const Offset(0.5, 0.5), duration: 500.ms, curve: Curves.elasticOut);
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: const Icon(Icons.business_rounded, color: AppColors.primary, size: 36),
    );
  }
}

class _MatchHeadline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      AppConstants.itsAMatch,
      style: AppTextStyles.display.copyWith(color: AppColors.primary),
      textAlign: TextAlign.center,
    )
        .animate(delay: 300.ms)
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut);
  }
}

class _JobTitle extends StatelessWidget {
  const _JobTitle({required this.title, required this.company});
  final String? title;
  final String? company;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title ?? 'Job Position',
          style: AppTextStyles.headlineSm,
          textAlign: TextAlign.center,
        ),
        if (company != null) ...[
          const SizedBox(height: 4),
          Text(
            '@ $company',
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    ).animate(delay: 400.ms).fadeIn(duration: 300.ms);
  }
}

class _ScoreCircle extends StatelessWidget {
  const _ScoreCircle({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _scoreColor(score).withValues(alpha: 0.4),
          width: 3,
        ),
        gradient: RadialGradient(
          colors: [
            _scoreColor(score).withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: score),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOut,
            builder: (context, value, _) {
              return Text(
                '$value',
                style: AppTextStyles.matchScore.copyWith(
                  color: _scoreColor(value),
                ),
              );
            },
          ),
          Text(
            'MATCH',
            style: AppTextStyles.label.copyWith(
              letterSpacing: 2,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate(delay: 500.ms).scale(
          begin: const Offset(0.6, 0.6),
          duration: 600.ms,
          curve: Curves.elasticOut,
        );
  }

  Color _scoreColor(int s) {
    if (s >= 80) return AppColors.accent;
    if (s >= 60) return AppColors.matchGold;
    return AppColors.textSecondary;
  }
}

class _ScoreBreakdown extends StatelessWidget {
  const _ScoreBreakdown({required this.reason});
  final MatchReasonModel reason;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reason.matchSummary,
          style: AppTextStyles.bodyMd,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        _DimensionBar(
          label: 'Skills',
          score: reason.skills.score,
          maxScore: 40,
          color: AppColors.primary,
          delay: 700.ms,
        ),
        _DimensionBar(
          label: 'Salary',
          score: reason.salary.score,
          maxScore: 25,
          color: AppColors.accent,
          delay: 800.ms,
        ),
        _DimensionBar(
          label: 'Work Style',
          score: reason.workStyle.score,
          maxScore: 20,
          color: AppColors.matchGold,
          delay: 900.ms,
        ),
        _DimensionBar(
          label: 'Experience',
          score: reason.experience.score,
          maxScore: 15,
          color: AppColors.superLike,
          delay: 1000.ms,
        ),
      ],
    ).animate(delay: 650.ms).fadeIn(duration: 400.ms);
  }
}

class _DimensionBar extends StatelessWidget {
  const _DimensionBar({
    required this.label,
    required this.score,
    required this.maxScore,
    required this.color,
    required this.delay,
  });

  final String label;
  final int score;
  final int maxScore;
  final Color color;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(label, style: AppTextStyles.bodyMd),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: score / maxScore),
                duration: const Duration(milliseconds: 1200),
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
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 32,
            child: Text(
              '$score',
              style: AppTextStyles.label.copyWith(color: color),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    ).animate(delay: delay).fadeIn(duration: 300.ms).slideX(begin: 0.1);
  }
}

class _CoachingTip extends StatelessWidget {
  const _CoachingTip({required this.tip});
  final String tip;

  @override
  Widget build(BuildContext context) {
    if (tip.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
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
    ).animate(delay: 1100.ms).fadeIn(duration: 400.ms);
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.matchId});
  final String matchId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          label: AppConstants.sendMessage,
          onPressed: () => context.push(AppRoutes.chatPath(matchId)),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.feed),
          child: Text(
            AppConstants.keepSwiping,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    ).animate(delay: 1200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}
