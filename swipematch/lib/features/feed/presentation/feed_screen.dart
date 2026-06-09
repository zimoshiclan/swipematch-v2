import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/feed_providers.dart';
import '../domain/feed_state.dart';
import '../presentation/widgets/deck_empty_state.dart';
import '../presentation/widgets/job_card.dart';
import '../../profile/domain/profile_providers.dart';
import '../../profile/presentation/widgets/completion_bar.dart';
import '../../../router/app_router.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/loading_skeleton.dart';
import '../../../shared/widgets/streak_badge.dart';
import '../../../shared/widgets/swipe_action_button.dart';

class FeedScreen extends HookConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => CardSwiperController(), []);
    useEffect(() => controller.dispose, []);

    final feedAsync = ref.watch(feedNotifierProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final pendingMatchId = ref.watch(pendingMatchIdProvider);

    useEffect(() {
      if (pendingMatchId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(pendingMatchIdProvider.notifier).state = null;
          context.push(AppRoutes.matchRevealPath(pendingMatchId));
        });
      }
      return null;
    }, [pendingMatchId]);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(profileAsync: profileAsync),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: profileAsync.when(
                data: (p) => p != null
                    ? CompletionBar(percent: p.profileCompletion / 100.0)
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
            _Greeting(profileAsync: profileAsync),
            Expanded(
              child: feedAsync.when(
                loading: () => const Center(child: JobCardSkeleton()),
                error: (e, _) => _ErrorState(onRetry: () => ref.invalidate(feedNotifierProvider)),
                data: (feedState) => feedState.isDeckEmpty || feedState.deck.isEmpty
                    ? const DeckEmptyState()
                    : _DeckView(
                        feedState: feedState,
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
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text('SwipeMatch', style: AppTextStyles.headlineSm),
          const Spacer(),
          if (profile != null) StreakBadge(count: profile.streakCount),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.profileAsync});
  final AsyncValue profileAsync;

  @override
  Widget build(BuildContext context) {
    final profile = profileAsync.valueOrNull;
    if (profile == null) return const SizedBox.shrink();

    final skills = profile.skills;
    final snippet = skills.length >= 2
        ? '${skills[0]} + ${skills[1]}'
        : skills.isNotEmpty
            ? skills[0]
            : profile.name.split(' ').first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md, 0, AppSpacing.md, AppSpacing.xs,
      ),
      child: Text(
        'Your $snippet skills are in demand today',
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}

class _DeckView extends StatelessWidget {
  const _DeckView({
    required this.feedState,
    required this.controller,
    required this.ref,
  });

  final FeedState feedState;
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
            cardsCount: feedState.deck.length,
            numberOfCardsDisplayed: feedState.deck.length.clamp(1, 3),
            backCardOffset: const Offset(0, 20),
            scale: 0.95,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            onSwipe: (prevIndex, currentIndex, direction) {
              final job = feedState.deck[prevIndex];
              final notifier = ref.read(feedNotifierProvider.notifier);
              switch (direction) {
                case CardSwiperDirection.right:
                  notifier.onSwipeRight(job);
                case CardSwiperDirection.left:
                  notifier.onSwipeLeft(job);
                case CardSwiperDirection.top:
                  notifier.onSuperLike(job);
                default:
                  break;
              }
              if (currentIndex == null) notifier.onDeckEmpty();
              return true;
            },
            cardBuilder: (context, index, horizontalThreshold, verticalThreshold) {
              return JobCard(
                job: feedState.deck[index],
                horizontalThreshold: horizontalThreshold,
                verticalThreshold: verticalThreshold,
              );
            },
          ),
        ),
        if (feedState.showMomentumOverlay)
          _MomentumOverlay(
            onDismiss: () => ref.read(feedNotifierProvider.notifier).dismissMomentum(),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _ActionButtons(controller: controller),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.controller});
  final CardSwiperController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            action: SwipeAction.superLike,
            size: 48,
            onTap: () => controller.swipe(CardSwiperDirection.top),
          ),
          SwipeActionButton(
            action: SwipeAction.right,
            size: 58,
            onTap: () => controller.swipe(CardSwiperDirection.right),
          ),
        ],
      ),
    );
  }
}

class _MomentumOverlay extends StatelessWidget {
  const _MomentumOverlay({required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: AppColors.overlay,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🚀', style: TextStyle(fontSize: 64))
                  .animate()
                  .scale(
                    begin: const Offset(0.4, 0.4),
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  ),
              const SizedBox(height: AppSpacing.md),
              Text(
                AppConstants.momentumMessage,
                style: AppTextStyles.display,
                textAlign: TextAlign.center,
              ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.sm),
              Text('Tap anywhere to continue', style: AppTextStyles.bodyMd)
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 300.ms),
            ],
          ),
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
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.danger,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Failed to load jobs', style: AppTextStyles.headlineSm),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
