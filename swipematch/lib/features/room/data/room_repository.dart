import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/constants/supabase_constants.dart';
import '../../profile/domain/profile_model.dart';

class RoomRepository {
  RoomRepository(this._supabase);
  final SupabaseClient _supabase;

  // Fetch today's room via the get_room_deck RPC (migration 019). The server
  // derives the viewer from auth.uid() and ranks by region (same city →
  // country) → shared connection-intent overlap → profile completion, then
  // appends a couple of random "serendipity" wildcards. Already-swiped and
  // passive profiles are excluded server-side.
  Future<List<ProfileModel>> getDailyRoom(String myProfileId, String myUserId) async {
    final rows = await _supabase.rpc(
      'get_room_deck',
      params: {'p_limit': 15},
    ) as List;

    return rows.map((r) {
      final row = r as Map<String, dynamic>;
      final profile =
          ProfileModel.fromJson(row['profile'] as Map<String, dynamic>);
      return profile.copyWith(
        isSerendipity: row['is_wildcard'] as bool? ?? false,
      );
    }).toList();
  }

  // Record the swipe via the SECURITY DEFINER RPC and return whether a
  // mutual connection was created. The swiper's identity is derived
  // server-side from auth.uid() — never trusted from the client (see
  // migration 017), so only the target and direction are sent.
  Future<({bool connected, String? matchId})> recordSwipe({
    required String targetProfileId,
    required String direction, // 'right' | 'left' | 'super'
  }) async {
    final result = await _supabase.rpc('record_person_swipe', params: {
      'p_target_profile_id': targetProfileId,
      'p_direction':         direction,
    }) as Map<String, dynamic>;

    final connected = result['connected'] as bool? ?? false;
    final matchId   = result['match_id'] as String?;
    return (connected: connected, matchId: matchId);
  }
}
