import '../../profile/domain/profile_model.dart';

class RoomState {
  final List<ProfileModel> deck;
  final bool isDeckEmpty;
  final int sessionSwipeCount;
  final bool showMomentum;
  final ProfileModel? newConnection; // non-null → show connection reveal sheet
  final String? newMatchId;

  const RoomState({
    this.deck = const [],
    this.isDeckEmpty = false,
    this.sessionSwipeCount = 0,
    this.showMomentum = false,
    this.newConnection,
    this.newMatchId,
  });

  RoomState copyWith({
    List<ProfileModel>? deck,
    bool? isDeckEmpty,
    int? sessionSwipeCount,
    bool? showMomentum,
    ProfileModel? newConnection,
    String? newMatchId,
    bool clearConnection = false,
  }) {
    return RoomState(
      deck: deck ?? this.deck,
      isDeckEmpty: isDeckEmpty ?? this.isDeckEmpty,
      sessionSwipeCount: sessionSwipeCount ?? this.sessionSwipeCount,
      showMomentum: showMomentum ?? this.showMomentum,
      newConnection: clearConnection ? null : (newConnection ?? this.newConnection),
      newMatchId: clearConnection ? null : (newMatchId ?? this.newMatchId),
    );
  }
}
