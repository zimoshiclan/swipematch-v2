// ignore_for_file: unused_field
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/job_model.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/constants/supabase_constants.dart';

class FeedRepository {
  FeedRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<JobModel>> fetchDailyDeck(String userId) async {
    final swiped = await _supabase
        .from(SupabaseConstants.swipes)
        .select('target_id')
        .eq('user_id', userId)       // auth user UUID — matches swipes.user_id FK + RLS
        .eq('target_type', 'job');

    final swipedIds = List<String>.from(
      (swiped as List).map((s) => s['target_id'] as String),
    );

    final response = await _supabase
        .from(SupabaseConstants.jobs)
        .select('*, companies(name, logo_url, ghost_score)')
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .limit(50);

    final unswiped = (response as List)
        .where((j) => !swipedIds.contains(j['id'] as String))
        .take(AppConstants.dailyDeckSize)
        .toList();

    return unswiped.map((json) {
      final company = json['companies'] as Map<String, dynamic>?;
      final mapped = Map<String, dynamic>.from(json as Map);
      mapped['company_name'] = company?['name'];
      mapped['company_logo_url'] = company?['logo_url'];
      mapped['company_ghost_score'] = company?['ghost_score'];
      mapped.remove('companies');
      return JobModel.fromJson(mapped);
    }).toList();
  }

  Future<void> recordSwipe({
    required String userId,
    required String targetId,
    required String direction,
  }) async {
    await _supabase.from(SupabaseConstants.swipes).insert({
      'user_id': userId,
      'target_id': targetId,
      'target_type': 'job',
      'direction': direction,
    });
  }

  /// Calls the match-score Edge Function to score the match with Claude AI.
  /// Creates a match record if score >= threshold. Falls back to DB check.
  Future<String?> scoreAndMatch({
    required String candidateId,
    required String jobId,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        SupabaseConstants.fnMatchScore,
        body: {'candidateId': candidateId, 'jobId': jobId},
      );
      final data = response.data as Map<String, dynamic>?;
      return data?['matchId'] as String?;
    } catch (_) {
      // Edge Function not deployed yet — fall back to existing DB check
      return _checkForMatch(candidateId, jobId);
    }
  }

  Future<String?> _checkForMatch(String candidateId, String jobId) async {
    final result = await _supabase
        .from(SupabaseConstants.matches)
        .select('id')
        .eq('candidate_id', candidateId)
        .eq('job_id', jobId)
        .maybeSingle();
    return result?['id'] as String?;
  }
}
