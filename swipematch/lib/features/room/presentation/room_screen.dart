import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/room_providers.dart';
import '../domain/room_state.dart';
import 'widgets/person_swipe_card.dart';
import '../../reels/presentation/reels_view.dart';
import '../../profile/domain/profile_model.dart';
import '../../profile/domain/profile_providers.dart';
import '../../profile/presentation/widgets/completion_bar.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/utils/haptics.dart';
import '../../../shared/widgets/streak_badge.dart';
import '../../../shared/widgets/swipe_action_button.dart';

class RoomScreen extends HookConsumerWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => CardSwiperController(), []);
    useEffect(() => controller.dispose, []);

    final roomAsync  = ref.watch(roomNotifierProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final pending    = ref.watch(pendingConnectionProvider);
    final reelsMode  = useState(true);

    // Show connection reveal sheet when a mutual connection happens
    useEffect(() {
      if (pending == null) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(pendingConnectionProvider.notifier).state = null;
        _showConnectionReveal(context, pending.person, pending.matchId);
      });
      return null;
    }, [pending]);

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
            const SizedBox(height: AppSpacing.xs),
            _ViewToggle(
              reelsMode: reelsMode.value,
              onChanged: (v) => reelsMode.value = v,
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: roomAsync.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
                error: (e, _) => _ErrorState(
                    onRetry: () => ref.invalidate(roomNotifierProvider)),
                data: (roomState) => roomState.isDeckEmpty || roomState.deck.isEmpty
                    ? const _RoomEmptyState()
                    : reelsMode.value
                        ? ReelsView(deck: roomState.deck)
                        : _DeckView(
                            roomState: roomState,
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

  void _showConnectionReveal(BuildContext context, ProfileModel person, String? matchId) {
    AppHaptics.matchReveal();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ConnectionRevealSheet(person: person, matchId: matchId),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Top bar
// ─────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.profileAsync});
  final AsyncValue profileAsync;

  @override
  Widget build(BuildContext context) {
    final profile = profileAsync.valueOrNull;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
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
            child: const Icon(Icons.celebration_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('The Room', style: AppTextStyles.headlineSm),
              Text("People building things",
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const Spacer(),
          if (profile != null) StreakBadge(count: profile.streakCount),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Cards ⇄ Reels toggle
// ─────────────────────────────────────────────────────────

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.reelsMode, required this.onChanged});
  final bool reelsMode;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _seg('Reels', Icons.play_circle_fill_rounded, reelsMode,
              () => onChanged(true)),
          _seg('Cards', Icons.style_rounded, !reelsMode, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _seg(String label, IconData icon, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: active ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  color: active ? Colors.white : AppColors.textSecondary,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Deck view
// ─────────────────────────────────────────────────────────

class _DeckView extends StatelessWidget {
  const _DeckView({
    required this.roomState,
    required this.controller,
    required this.ref,
  });

  final RoomState roomState;
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
            cardsCount: roomState.deck.length,
            numberOfCardsDisplayed: roomState.deck.length.clamp(1, 3),
            backCardOffset: const Offset(0, 20),
            scale: 0.94,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            onSwipe: (prevIdx, curIdx, direction) {
              final person = roomState.deck[prevIdx];
              final notifier = ref.read(roomNotifierProvider.notifier);
              switch (direction) {
                case CardSwiperDirection.right:
                  notifier.onSwipeRight(person);
                case CardSwiperDirection.left:
                  notifier.onSwipePast(person);
                case CardSwiperDirection.top:
                  notifier.onSuperConnect(person);
                default:
                  break;
              }
              if (curIdx == null) notifier.onDeckEmpty();
              return true;
            },
            cardBuilder: (ctx, idx, hThresh, vThresh) => PersonSwipeCard(
              person: roomState.deck[idx],
              horizontalThreshold: hThresh,
              verticalThreshold: vThresh,
            ),
          ),
        ),
        // Action buttons
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: _ActionButtons(controller: controller),
        ),
        // Momentum overlay
        if (roomState.showMomentum)
          _MomentumOverlay(
              onDismiss: () =>
                  ref.read(roomNotifierProvider.notifier).dismissMomentum()),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Action buttons
// ─────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.controller});
  final CardSwiperController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SwipeActionButton(
          icon: Icons.close_rounded,
          color: AppColors.textSecondary,
          size: 52,
          onTap: () => controller.swipe(CardSwiperDirection.left),
        ),
        const SizedBox(width: AppSpacing.md),
        SwipeActionButton(
          icon: Icons.auto_awesome_rounded,
          color: AppColors.primary,
          size: 44,
          onTap: () => controller.swipe(CardSwiperDirection.top),
        ),
        const SizedBox(width: AppSpacing.md),
        SwipeActionButton(
          icon: Icons.handshake_rounded,
          color: AppColors.accent,
          size: 52,
          onTap: () => controller.swipe(CardSwiperDirection.right),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Connection reveal bottom sheet
// ─────────────────────────────────────────────────────────

class _ConnectionRevealSheet extends StatelessWidget {
  const _ConnectionRevealSheet({required this.person, this.matchId});
  final ProfileModel person;
  final String? matchId;

  @override
  Widget build(BuildContext context) {
    final initials = person.name.isNotEmpty
        ? person.name.split(' ').take(2).map((w) => w[0]).join().toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF00C9A7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.celebration_rounded,
              color: Colors.white, size: 48)
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: AppSpacing.md),
          Text(
            "You're connected!",
            style: AppTextStyles.headlineLg.copyWith(color: Colors.white),
          ).animate(delay: 100.ms).fadeIn(),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5), width: 2),
            ),
            child: Center(
              child: Text(
                initials,
                style: AppTextStyles.headlineLg.copyWith(color: Colors.white),
              ),
            ),
          ).animate(delay: 150.ms).scale(curve: Curves.elasticOut, duration: 500.ms),
          const SizedBox(height: AppSpacing.sm),
          Text(
            person.name,
            style: AppTextStyles.headlineSm.copyWith(color: Colors.white),
          ).animate(delay: 200.ms).fadeIn(),
          if (person.workingToward != null &&
              person.workingToward!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              person.workingToward!,
              style: AppTextStyles.bodyMd
                  .copyWith(color: Colors.white.withValues(alpha: 0.85)),
              textAlign: TextAlign.center,
              maxLines: 2,
            ).animate(delay: 250.ms).fadeIn(),
          ],
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text('Keep exploring',
                  style: AppTextStyles.buttonText
                      .copyWith(color: const Color(0xFF6C63FF))),
            ),
          ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Momentum overlay
// ─────────────────────────────────────────────────────────

class _MomentumOverlay extends StatelessWidget {
  const _MomentumOverlay({required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 64))
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.elasticOut),
              const SizedBox(height: AppSpacing.md),
              Text("You're on a roll!",
                  style: AppTextStyles.headlineLg.copyWith(color: Colors.white)),
              const SizedBox(height: AppSpacing.sm),
              Text('Keep going',
                  style: AppTextStyles.bodyMd
                      .copyWith(color: Colors.white.withValues(alpha: 0.7))),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Empty and error states
// ─────────────────────────────────────────────────────────

class _RoomEmptyState extends StatelessWidget {
  const _RoomEmptyState();

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
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.celebration_rounded,
                  color: AppColors.primary, size: 40),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text("You've met everyone today",
                style: AppTextStyles.headlineSm, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "New people arrive tomorrow at 8am.\nCome back and see who showed up.",
              style:
                  AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
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
              color: AppColors.textSecondary, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text("Couldn't load the room",
              style: AppTextStyles.headlineSm, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
