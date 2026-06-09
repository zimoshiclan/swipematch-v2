import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../../shared/utils/currency_utils.dart';
import '../../../../shared/widgets/ghost_score_badge.dart';
import '../../../../shared/widgets/match_score_badge.dart';
import '../../../../shared/widgets/skill_tag.dart';
import '../../domain/job_model.dart';

class JobCard extends StatelessWidget {
  const JobCard({
    super.key,
    required this.job,
    this.horizontalThreshold = 0,
    this.verticalThreshold = 0,
  });

  final JobModel job;
  final int horizontalThreshold;
  final int verticalThreshold;

  @override
  Widget build(BuildContext context) {
    final expiresAt = job.expiresAt;
    final isNearExpiry = expiresAt != null &&
        expiresAt.difference(DateTime.now()).inHours <
            AppConstants.expiryWarningHours;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: isNearExpiry
            ? Border.all(color: AppColors.expiryRed, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          _CardContent(job: job),
          const _BottomGradient(),
          if (horizontalThreshold > 20) const _DirectionChip(isRight: true),
          if (horizontalThreshold < -20) const _DirectionChip(isRight: false),
          if (verticalThreshold < -20) const _SuperLikeChip(),
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopRow(job: job),
          const Spacer(),
          _JobInfo(job: job),
          const SizedBox(height: AppSpacing.sm),
          _SkillsRow(skills: job.requiredSkills),
          const SizedBox(height: AppSpacing.sm),
          _BottomMeta(job: job),
        ],
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CompanyLogo(logoUrl: job.companyLogoUrl, name: job.companyName ?? ''),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.companyName ?? 'Company',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(_workStyleLabel(job.workStyle), style: AppTextStyles.label),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (job.isHot) const _HotBadge(),
            if (job.matchScore > 0) ...[
              const SizedBox(height: 4),
              MatchScoreBadge(score: job.matchScore),
            ],
            if (job.companyGhostScore != null && job.companyGhostScore! < 90) ...[
              const SizedBox(height: 4),
              GhostScoreBadge(score: job.companyGhostScore!, compact: true),
            ],
          ],
        ),
      ],
    );
  }

  String _workStyleLabel(String style) => switch (style) {
        'remote' => '🌎 Remote',
        'hybrid' => '🏢 Hybrid',
        'on_site' => '🏙️ On-site',
        _ => style,
      };
}

class _JobInfo extends StatelessWidget {
  const _JobInfo({required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          job.title,
          style: AppTextStyles.headlineLg,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          CurrencyUtils.formatRange(job.salaryMin, job.salaryMax),
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.accent),
        ),
      ],
    );
  }
}

class _SkillsRow extends StatelessWidget {
  const _SkillsRow({required this.skills});
  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    final shown = skills.take(3).toList();
    final overflow = skills.length - shown.length;
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        ...shown.map((s) => SkillTag(label: s)),
        if (overflow > 0) SkillTag(label: '+$overflow'),
      ],
    );
  }
}

class _BottomMeta extends StatelessWidget {
  const _BottomMeta({required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    final timeLeft = job.expiresAt?.difference(DateTime.now());
    final isNearExpiry =
        timeLeft != null && timeLeft.inHours < AppConstants.expiryWarningHours;

    return Row(
      children: [
        if (job.applicantCount > 0) ...[
          const Icon(
            Icons.people_outline_rounded,
            size: 13,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text('${job.applicantCount} applied', style: AppTextStyles.label),
        ],
        const Spacer(),
        if (timeLeft != null && !timeLeft.isNegative && isNearExpiry)
          _ExpiryChip(timeLeft: timeLeft),
      ],
    );
  }
}

class _CompanyLogo extends StatelessWidget {
  const _CompanyLogo({required this.logoUrl, required this.name});
  final String? logoUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: logoUrl != null
            ? CachedNetworkImage(
                imageUrl: logoUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _LogoFallback(name: name),
                errorWidget: (_, __, ___) => _LogoFallback(name: name),
              )
            : _LogoFallback(name: name),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Text(
          letter,
          style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _HotBadge extends StatelessWidget {
  const _HotBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.hotBadge.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.hotBadge.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 11)),
          const SizedBox(width: 3),
          Text(
            'Hot',
            style: AppTextStyles.label.copyWith(
              color: AppColors.hotBadge,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiryChip extends StatelessWidget {
  const _ExpiryChip({required this.timeLeft});
  final Duration timeLeft;

  @override
  Widget build(BuildContext context) {
    final h = timeLeft.inHours;
    final m = timeLeft.inMinutes % 60;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.expiryRed.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border:
            Border.all(color: AppColors.expiryRed.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined,
              size: 11, color: AppColors.expiryRed),
          const SizedBox(width: 3),
          Text(
            h > 0 ? '${h}h ${m}m' : '${m}m',
            style: AppTextStyles.label.copyWith(
              color: AppColors.expiryRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomGradient extends StatelessWidget {
  const _BottomGradient();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 140,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(AppSpacing.cardRadius),
            bottomRight: Radius.circular(AppSpacing.cardRadius),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.cardGradientStart,
              AppColors.cardGradientEnd,
            ],
          ),
        ),
      ),
    );
  }
}

class _DirectionChip extends StatelessWidget {
  const _DirectionChip({required this.isRight});
  final bool isRight;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.lg,
      left: isRight ? AppSpacing.lg : null,
      right: isRight ? null : AppSpacing.lg,
      child: Transform.rotate(
        angle: isRight ? -0.3 : 0.3,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: isRight ? AppColors.accent : AppColors.danger,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isRight ? 'MATCH' : 'NOPE',
            style: AppTextStyles.headlineSm.copyWith(
              color: isRight ? AppColors.accent : AppColors.danger,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _SuperLikeChip extends StatelessWidget {
  const _SuperLikeChip();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppSpacing.xl,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.superLike, width: 3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'SUPER',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.superLike,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
