import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/match_model.dart';
import '../domain/match_providers.dart';
import '../../profile/domain/profile_providers.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/match_score_badge.dart';

class MatchListScreen extends HookConsumerWidget {
  const MatchListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: context.canPop()
            ? IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.textPrimary, size: 20),
              )
            : null,
        title: Text('Your Matches', style: AppTextStyles.headlineSm),
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Could not load profile', style: AppTextStyles.bodyMd),
        ),
        data: (profile) {
          if (profile == null) return const SizedBox.shrink();
          final matchesAsync = ref.watch(matchListProvider(profile.id));
          return matchesAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (e, _) => Center(
              child: Text('Failed to load matches', style: AppTextStyles.bodyMd),
            ),
            data: (matches) => matches.isEmpty
                ? _EmptyState()
                : _MatchList(matches: matches),
          );
        },
      ),
    );
  }
}

class _MatchList extends StatelessWidget {
  const _MatchList({required this.matches});
  final List<MatchModel> matches;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: matches.length,
      itemBuilder: (context, i) {
        return _MatchCard(match: matches[i])
            .animate(delay: Duration(milliseconds: i * 60))
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.05);
      },
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.match});
  final MatchModel match;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.chatPath(match.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _LogoCircle(logoUrl: match.companyLogoUrl),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.jobTitle ?? 'Job Position',
                    style: AppTextStyles.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    match.companyName ?? 'Company',
                    style: AppTextStyles.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MatchScoreBadge(score: match.matchScore),
                const SizedBox(height: 4),
                Text(
                  _statusLabel(match.status),
                  style: AppTextStyles.label.copyWith(
                    color: _statusColor(match.status),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String status) => switch (status) {
        'new_match' => 'New',
        'contacted' => 'Active',
        'interview_scheduled' => 'Interview',
        'offer_sent' => 'Offer',
        'hired' => 'Hired',
        _ => status,
      };

  Color _statusColor(String status) => switch (status) {
        'new_match' => AppColors.primary,
        'contacted' => AppColors.accent,
        'interview_scheduled' => AppColors.matchGold,
        'offer_sent' => AppColors.hotBadge,
        'hired' => AppColors.accent,
        _ => AppColors.textSecondary,
      };
}

class _LogoCircle extends StatelessWidget {
  const _LogoCircle({required this.logoUrl});
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
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
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: const Icon(Icons.business_rounded,
          color: AppColors.primary, size: 24),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_outline_rounded,
                  color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('No matches yet', style: AppTextStyles.headlineSm),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Keep swiping to find your perfect match!',
              style: AppTextStyles.bodyMd,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
