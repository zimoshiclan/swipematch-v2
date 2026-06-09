import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/employer_repository.dart';
import 'candidate_card_model.dart';
import '../../match/domain/match_model.dart';
import '../../profile/domain/profile_providers.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/utils/haptics.dart';

final employerRepositoryProvider = Provider<EmployerRepository>((ref) {
  return EmployerRepository(Supabase.instance.client);
});

// ── Candidate deck notifier ──────────────────────────────────────────────────

final employerFeedNotifierProvider = AutoDisposeAsyncNotifierProvider<
    EmployerFeedNotifier, List<CandidateCardModel>>(EmployerFeedNotifier.new);

class EmployerFeedNotifier
    extends AutoDisposeAsyncNotifier<List<CandidateCardModel>> {
  @override
  Future<List<CandidateCardModel>> build() async {
    final profile = await ref.watch(currentProfileProvider.future);
    if (profile == null) return [];
    return ref.read(employerRepositoryProvider).fetchCandidateDeck(
          employerProfileId: profile.id,
          employerUserId: profile.userId,
        );
  }

  Future<void> onSwipeRight(CandidateCardModel candidate) async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null) return;
    AppHaptics.swipeRight();
    await ref.read(employerRepositoryProvider).recordCandidateSwipe(
      employerUserId: profile.userId,
      candidateId: candidate.id,
      direction: AppConstants.swipeRight,
    );
  }

  Future<void> onSwipeLeft(CandidateCardModel candidate) async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null) return;
    AppHaptics.swipeLeft();
    await ref.read(employerRepositoryProvider).recordCandidateSwipe(
      employerUserId: profile.userId,
      candidateId: candidate.id,
      direction: AppConstants.swipeLeft,
    );
  }
}

// ── Pipeline notifier ────────────────────────────────────────────────────────

final pipelineNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PipelineNotifier, List<MatchModel>>(
        PipelineNotifier.new);

class PipelineNotifier extends AutoDisposeAsyncNotifier<List<MatchModel>> {
  @override
  Future<List<MatchModel>> build() async {
    final profile = await ref.watch(currentProfileProvider.future);
    if (profile == null) return [];
    final repo = ref.read(employerRepositoryProvider);
    final companyId = await repo.fetchCompanyId(profile.id);
    if (companyId == null) return [];
    return repo.fetchPipelineMatches(companyId);
  }

  Future<void> updateStatus(String matchId, String newStatus) async {
    final current = state.valueOrNull ?? [];
    state = AsyncData(
      current.map((m) => m.id == matchId ? m.copyWith(status: newStatus) : m).toList(),
    );
    await ref.read(employerRepositoryProvider).updateMatchStatus(matchId, newStatus);
  }
}
