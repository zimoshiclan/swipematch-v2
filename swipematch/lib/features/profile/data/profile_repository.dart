// ignore_for_file: unused_field
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/constants/supabase_constants.dart';
import '../domain/profile_model.dart';

class ProfileRepository {
  ProfileRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<ProfileModel?> fetchProfile(String userId) async {
    final data = await _supabase
        .from(SupabaseConstants.profiles)
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (data == null) return null;
    return ProfileModel.fromJson(data);
  }

  Future<ProfileModel> createProfile({
    required String userId,
    required String role,
    required String name,
  }) async {
    // upsert so re-tapping after a failed attempt doesn't throw a duplicate key error
    final data = await _supabase
        .from(SupabaseConstants.profiles)
        .upsert(
          {
            'user_id': userId,
            'role': role,
            'name': name,
            'profile_completion': 0,
            'streak_count': 0,
            'passive_mode': false,
          },
          onConflict: 'user_id',
        )
        .select()
        .single();

    return ProfileModel.fromJson(data);
  }

  Future<ProfileModel> updateProfile({
    required String profileId,
    required Map<String, dynamic> updates,
  }) async {
    final data = await _supabase
        .from(SupabaseConstants.profiles)
        .update(updates)
        .eq('id', profileId)
        .select()
        .single();

    return ProfileModel.fromJson(data);
  }

  Future<void> togglePassiveMode(String profileId, bool passive) async {
    await _supabase
        .from(SupabaseConstants.profiles)
        .update({'passive_mode': passive}).eq('id', profileId);
  }

  Future<void> updateStreak(String profileId) async {
    final profile = await _supabase
        .from(SupabaseConstants.profiles)
        .select('streak_count, last_active_date')
        .eq('id', profileId)
        .single();

    final lastActive = profile['last_active_date'] != null
        ? DateTime.parse(profile['last_active_date'])
        : null;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (lastActive == null) {
      await _supabase.from(SupabaseConstants.profiles).update({
        'streak_count': 1,
        'last_active_date': todayDate.toIso8601String(),
      }).eq('id', profileId);
      return;
    }

    final lastActiveDate = DateTime(lastActive.year, lastActive.month, lastActive.day);
    if (lastActiveDate == todayDate) return; // already updated today

    final daysDiff = todayDate.difference(lastActiveDate).inDays;
    final newStreak = daysDiff == 1 ? (profile['streak_count'] as int) + 1 : 1;

    await _supabase.from(SupabaseConstants.profiles).update({
      'streak_count': newStreak,
      'last_active_date': todayDate.toIso8601String(),
    }).eq('id', profileId);
  }
}
