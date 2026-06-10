import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/constants/supabase_constants.dart';
import '../../profile/domain/profile_model.dart';

class RoomRepository {
  RoomRepository(this._supabase);
  final SupabaseClient _supabase;

  // Fetch today's room — profiles this user hasn't swiped on yet, sorted by
  // profile completion so more complete profiles surface first.
  Future<List<ProfileModel>> getDailyRoom(String myProfileId, String myUserId) async {
    // Get profile IDs already swiped today
    final today = DateTime.now();
    final dayStart = DateTime(today.year, today.month, today.day).toIso8601String();

    final swiped = await _supabase
        .from(SupabaseConstants.swipes)
        .select('target_id')
        .eq('user_id', myUserId)
        .eq('target_type', 'person')
        .gte('created_at', dayStart) as List;

    final swipedIds = <String>{
      myProfileId,
      ...swiped.map((s) => s['target_id'] as String),
    };

    // Fetch candidate profiles (limit 50, filter client-side to 15 after exclusions)
    final rows = await _supabase
        .from(SupabaseConstants.profiles)
        .select()
        .order('profile_completion', ascending: false)
        .limit(50) as List;

    return rows
        .where((r) => !swipedIds.contains(r['id'] as String))
        .take(15)
        .map((r) => ProfileModel.fromJson(r as Map<String, dynamic>))
        .toList();
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
