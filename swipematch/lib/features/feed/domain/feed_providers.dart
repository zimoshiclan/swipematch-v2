import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/feed_repository.dart';
import 'feed_state.dart';
import 'job_model.dart';
import '../../profile/domain/profile_providers.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/utils/haptics.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(Supabase.instance.client);
});

// Navigation signal: non-null triggers push to match reveal
final pendingMatchIdProvider = StateProvider<String?>((ref) => null);

final feedNotifierProvider =
    AutoDisposeAsyncNotifierProvider<FeedNotifier, FeedState>(FeedNotifier.new);

class FeedNotifier extends AutoDisposeAsyncNotifier<FeedState> {
  @override
  Future<FeedState> build() async {
    final profile = await ref.watch(currentProfileProvider.future);
    if (profile == null) return const FeedState();
    // Pass the auth user UUID for the swipes filter (swipes.user_id FK → auth.users)
    final deck =
        await ref.read(feedRepositoryProvider).fetchDailyDeck(profile.userId);
    return FeedState(deck: deck, isDeckEmpty: deck.isEmpty);
  }

  Future<void> onSwipeRight(JobModel job) async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null) return;
    AppHaptics.swipeRight();
    final repo = ref.read(feedRepositoryProvider);
    await repo.recordSwipe(
      userId: profile.userId,     // auth user UUID — satisfies FK + RLS
      targetId: job.id,
      direction: AppConstants.swipeRight,
    );
    final matchId = await repo.scoreAndMatch(candidateId: profile.id, jobId: job.id);
    if (matchId != null) {
      ref.read(pendingMatchIdProvider.notifier).state = matchId;
    }
    _bumpSwipeCount();
  }

  Future<void> onSwipeLeft(JobModel job) async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null) return;
    AppHaptics.swipeLeft();
    await ref.read(feedRepositoryProvider).recordSwipe(
      userId: profile.userId,     // auth user UUID — satisfies FK + RLS
      targetId: job.id,
      direction: AppConstants.swipeLeft,
    );
    _bumpSwipeCount();
  }

  Future<void> onSuperLike(JobModel job) async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null) return;
    AppHaptics.superLike();
    final repo = ref.read(feedRepositoryProvider);
    await repo.recordSwipe(
      userId: profile.userId,     // auth user UUID — satisfies FK + RLS
      targetId: job.id,
      direction: AppConstants.superLike,
    );
    final matchId = await repo.scoreAndMatch(candidateId: profile.id, jobId: job.id);
    if (matchId != null) {
      ref.read(pendingMatchIdProvider.notifier).state = matchId;
    }
    _bumpSwipeCount();
  }

  void dismissMomentum() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(showMomentumOverlay: false));
  }

  void onDeckEmpty() {
    final current = state.valueOrNull ?? const FeedState();
    state = AsyncData(current.copyWith(isDeckEmpty: true));
  }

  void _bumpSwipeCount() {
    final current = state.valueOrNull;
    if (current == null) return;
    final newCount = current.sessionSwipeCount + 1;
    state = AsyncData(current.copyWith(
      sessionSwipeCount: newCount,
      showMomentumOverlay: newCount == AppConstants.momentumSwipeCount,
    ));
  }
}
