import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/constants/supabase_constants.dart';

/// Backing data layer for the briefing's "Skills battle" V2 feature. The
/// schema (`skills_scores`) ships in migration 004; this repository unblocks
/// future UI work (battle screen + leaderboards) without forcing a second
/// migration round.
class SkillsScoreRepository {
  SkillsScoreRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Map<String, dynamic>>> getScores(String candidateId) async {
    final rows = await _supabase
        .from(SupabaseConstants.skillsScores)
        .select()
        .eq('candidate_id', candidateId)
        .order('taken_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Records a self-attested battle result. Verified flag is forced to false;
  /// the corresponding RLS policy blocks user-side verification.
  Future<void> recordResult({
    required String candidateId,
    required String skillName,
    required int score,
  }) async {
    final clamped = score.clamp(0, 100);
    await _supabase.from(SupabaseConstants.skillsScores).upsert({
      'candidate_id': candidateId,
      'skill_name': skillName,
      'score': clamped,
      'verified': false,
      'taken_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'candidate_id,skill_name');
  }
}

final skillsScoreRepositoryProvider = Provider<SkillsScoreRepository>(
  (ref) => SkillsScoreRepository(Supabase.instance.client),
);

final mySkillsScoresProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) return [];
  final profile = await supabase
      .from(SupabaseConstants.profiles)
      .select('id')
      .eq('user_id', user.id)
      .maybeSingle();
  final id = profile?['id'] as String?;
  if (id == null) return [];
  return ref.read(skillsScoreRepositoryProvider).getScores(id);
});
