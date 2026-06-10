import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/room_repository.dart';
import 'room_state.dart';
import '../../profile/domain/profile_model.dart';
import '../../profile/domain/profile_providers.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/utils/haptics.dart';

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  return RoomRepository(Supabase.instance.client);
});

// Signals the room screen to show the connection reveal sheet
final pendingConnectionProvider =
    StateProvider<({ProfileModel person, String? matchId})?>((_) => null);

final roomNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RoomNotifier, RoomState>(RoomNotifier.new);

class RoomNotifier extends AutoDisposeAsyncNotifier<RoomState> {
  @override
  Future<RoomState> build() async {
    final profile = await ref.watch(currentProfileProvider.future);
    if (profile == null) return const RoomState();
    final deck = await ref
        .read(roomRepositoryProvider)
        .getDailyRoom(profile.id, profile.userId);
    return RoomState(deck: deck, isDeckEmpty: deck.isEmpty);
  }

  Future<void> onSwipeRight(ProfileModel person) async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null) return;
    AppHaptics.swipeRight();
    final result = await ref.read(roomRepositoryProvider).recordSwipe(
          targetProfileId: person.id,
          direction: AppConstants.swipeRight,
        );
    if (result.connected) {
      ref.read(pendingConnectionProvider.notifier).state =
          (person: person, matchId: result.matchId);
    }
    _bump();
  }

  Future<void> onSwipePast(ProfileModel person) async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null) return;
    AppHaptics.swipeLeft();
    await ref.read(roomRepositoryProvider).recordSwipe(
          targetProfileId: person.id,
          direction: AppConstants.swipeLeft,
        );
    _bump();
  }

  Future<void> onSuperConnect(ProfileModel person) async {
    final profile = await ref.read(currentProfileProvider.future);
    if (profile == null) return;
    AppHaptics.superLike();
    final result = await ref.read(roomRepositoryProvider).recordSwipe(
          targetProfileId: person.id,
          direction: AppConstants.superLike,
        );
    if (result.connected) {
      ref.read(pendingConnectionProvider.notifier).state =
          (person: person, matchId: result.matchId);
    }
    _bump();
  }

  void onDeckEmpty() {
    final s = state.valueOrNull ?? const RoomState();
    state = AsyncData(s.copyWith(isDeckEmpty: true));
  }

  void dismissMomentum() {
    final s = state.valueOrNull;
    if (s == null) return;
    state = AsyncData(s.copyWith(showMomentum: false));
  }

  void _bump() {
    final s = state.valueOrNull;
    if (s == null) return;
    final n = s.sessionSwipeCount + 1;
    state = AsyncData(s.copyWith(
      sessionSwipeCount: n,
      showMomentum: n == AppConstants.momentumSwipeCount,
    ));
  }
}
