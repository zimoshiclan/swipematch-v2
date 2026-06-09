import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/candidate_card_model.dart';
import '../domain/employer_providers.dart';
import '../../profile/domain/profile_providers.dart';
import '../../pitch/presentation/pitch_preview_screen.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/loading_skeleton.dart';
import '../../../shared/widgets/skill_tag.dart';
import '../../../shared/widgets/streak_badge.dart';
import '../../../shared/widgets/swipe_action_button.dart';

class EmployerFeedScreen extends HookConsumerWidget {
  const EmployerFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => CardSwiperController(), []);
    useEffect(() => controller.dispose, []);

    final deckAsync = ref.watch(employerFeedNotifierProvider);
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(profileAsync: profileAsync),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _EmployerGreeting(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: deckAsync.when(
                loading: () => const Center(child: JobCardSkeleton()),
                error: (e, _) => _ErrorState(
                  onRetry: () => ref.invalidate(employerFeedNotifierProvider),
                ),
                data: (deck) => deck.isEmpty
                    ? const _EmptyDeck()
                    : _CandidateDeckView(
                        deck: deck,
                        controller: controller,
                        ref: ref,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.profileAsync});
  final AsyncValue profileAsync;

  @override
  Widget build(BuildContext context) {
    final profile = profileAsync.valueOrNull;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.business_center_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text('Talent Pool', style: AppTextStyles.headlineSm),
          const Spacer(),
          if (profile != null) StreakBadge(count: profile.streakCount),
        ],
      ),
    );
  }
}

class _EmployerGreeting extends StatelessWidget {
  const _EmployerGreeting();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Candidates who want to work with you',
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}

class _CandidateDeckView extends StatelessWidget {
  const _CandidateDeckView({
    required this.deck,
    required this.controller,
    required this.ref,
  });

  final List<CandidateCardModel> deck;
  final CardSwiperController controller;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: CardSwiper(
            controller: controller,
            cardsCount: deck.length,
            numberOfCardsDisplayed: deck.length.clamp(1, 3),
            backCardOffset: const Offset(0, 20),
            scale: 0.95,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            onSwipe: (prevIndex, currentIndex, direction) {
              final candidate = deck[prevIndex];
              final notifier = ref.read(employerFeedNotifierProvider.notifier);
              if (direction == CardSwiperDirection.right) {
                notifier.onSwipeRight(candidate);
              } else if (direction == CardSwiperDirection.left) {
                notifier.onSwipeLeft(candidate);
              }
              return true;
            },
            cardBuilder: (context, index, hThreshold, vThreshold) {
              return _CandidateCard(
                candidate: deck[index],
                horizontalThreshold: hThreshold,
              );
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SwipeActionButton(
                  action: SwipeAction.left,
                  size: 58,
                  onTap: () => controller.swipe(CardSwiperDirection.left),
                ),
                SwipeActionButton(
                  action: SwipeAction.right,
                  size: 58,
                  onTap: () => controller.swipe(CardSwiperDirection.right),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.candidate,
    this.horizontalThreshold = 0,
  });

  final CandidateCardModel candidate;
  final int horizontalThreshold;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
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
          Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AvatarRow(candidate: candidate),
                const Spacer(),
                Text(
                  candidate.name,
                  style: AppTextStyles.headlineLg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (candidate.headline != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    candidate.headline!,
                    style: AppTextStyles.bodyMd
                        .copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: candidate.skills
                      .take(4)
                      .map((s) => SkillTag(label: s))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.work_outline_rounded,
                        size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${candidate.experienceYears} yrs · ${_workLabel(candidate.workStyle)}',
                      style: AppTextStyles.label,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (horizontalThreshold > 20)
            const _DirectionOverlay(isRight: true),
          if (horizontalThreshold < -20)
            const _DirectionOverlay(isRight: false),
        ],
      ),
    );
  }

  String _workLabel(String style) => switch (style) {
        'remote' => '🌎 Remote',
        'hybrid' => '🏢 Hybrid',
        'on_site' => '🏙️ On-site',
        _ => style,
      };
}

class _AvatarRow extends StatelessWidget {
  const _AvatarRow({required this.candidate});
  final CandidateCardModel candidate;

  @override
  Widget build(BuildContext context) {
    final initials = candidate.name.isNotEmpty
        ? candidate.name.split(' ').take(2).map((w) => w[0]).join()
        : '?';
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials.toUpperCase(),
              style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary),
            ),
          ),
        ),
        const Spacer(),
        if (candidate.videoPitchUrl != null) ...[
          _PitchPlayButton(url: candidate.videoPitchUrl!),
          const SizedBox(width: AppSpacing.xs),
        ],
        if (candidate.matchScore > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
            ),
            child: Text(
              '${candidate.matchScore}%',
              style: AppTextStyles.label.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _PitchPlayButton extends StatelessWidget {
  const _PitchPlayButton({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              PitchPreviewScreen(remoteUrl: url, readOnly: true),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
        ),
        child: const Icon(Icons.play_arrow_rounded,
            color: AppColors.primary, size: 16),
      ),
    );
  }
}

class _DirectionOverlay extends StatelessWidget {
  const _DirectionOverlay({required this.isRight});
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
            isRight ? 'LIKE' : 'PASS',
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

class _EmptyDeck extends StatelessWidget {
  const _EmptyDeck();

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
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people_outline_rounded,
                  color: AppColors.accent, size: 36),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('No candidates yet', style: AppTextStyles.headlineSm),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Candidates who apply to your jobs will appear here.',
              style: AppTextStyles.bodyMd,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.danger, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text('Failed to load candidates', style: AppTextStyles.headlineSm),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onRetry,
            child: Text('Retry',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
