// ignore_for_file: unused_field
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/match_model.dart';
import '../../../shared/constants/supabase_constants.dart';

class MatchRepository {
  MatchRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<MatchModel?> fetchMatch(String matchId) async {
    final matchData = await _supabase
        .from(SupabaseConstants.matches)
        .select()
        .eq('id', matchId)
        .maybeSingle();

    if (matchData == null) return null;

    final jobData = await _supabase
        .from(SupabaseConstants.jobs)
        .select('title, companies(name, logo_url, ghost_score)')
        .eq('id', matchData['job_id'] as String)
        .maybeSingle();

    final candidateData = await _supabase
        .from(SupabaseConstants.profiles)
        .select('name, avatar_url, video_pitch_url')
        .eq('id', matchData['candidate_id'] as String)
        .maybeSingle();

    final company = jobData?['companies'] as Map<String, dynamic>?;

    final mapped = Map<String, dynamic>.from(matchData);
    mapped['job_title'] = jobData?['title'];
    mapped['company_name'] = company?['name'];
    mapped['company_logo_url'] = company?['logo_url'];
    mapped['company_ghost_score'] = company?['ghost_score'];
    mapped['candidate_name'] = candidateData?['name'];
    mapped['candidate_avatar_url'] = candidateData?['avatar_url'];
    mapped['candidate_video_pitch_url'] = candidateData?['video_pitch_url'];
    mapped['match_reason'] ??= _defaultMatchReason(
      (mapped['match_score'] as num?)?.toInt() ?? 0,
    );

    return MatchModel.fromJson(mapped);
  }

  Future<List<MatchModel>> fetchMatches(String candidateId) async {
    final matchRows = await _supabase
        .from(SupabaseConstants.matches)
        .select()
        .eq('candidate_id', candidateId)
        .order('created_at', ascending: false) as List;

    if (matchRows.isEmpty) return [];

    final jobIds = matchRows.map((m) => m['job_id'] as String).toSet().toList();
    final candidateIds = matchRows.map((m) => m['candidate_id'] as String).toSet().toList();

    final fetched = await Future.wait([
      _supabase
          .from(SupabaseConstants.jobs)
          .select('id, title, companies(name, logo_url, ghost_score)')
          .inFilter('id', jobIds),
      _supabase
          .from(SupabaseConstants.profiles)
          .select('id, name, avatar_url, video_pitch_url')
          .inFilter('id', candidateIds),
    ]);

    final jobMap = {
      for (final j in fetched[0] as List) (j as Map<String, dynamic>)['id'] as String: j
    };
    final candidateMap = {
      for (final c in fetched[1] as List) (c as Map<String, dynamic>)['id'] as String: c
    };

    return matchRows.map((m) {
      final mapped = Map<String, dynamic>.from(m as Map);
      final job = jobMap[mapped['job_id'] as String];
      final company = job?['companies'] as Map<String, dynamic>?;
      final candidate = candidateMap[mapped['candidate_id'] as String];
      mapped['job_title'] = job?['title'];
      mapped['company_name'] = company?['name'];
      mapped['company_logo_url'] = company?['logo_url'];
      mapped['company_ghost_score'] = company?['ghost_score'];
      mapped['candidate_name'] = candidate?['name'];
      mapped['candidate_avatar_url'] = candidate?['avatar_url'];
      mapped['candidate_video_pitch_url'] = candidate?['video_pitch_url'];
      mapped['match_reason'] ??= _defaultMatchReason(
        (mapped['match_score'] as num?)?.toInt() ?? 0,
      );
      return MatchModel.fromJson(mapped);
    }).toList();
  }

  MatchModel _matchFromRaw(Map<String, dynamic> raw) {
    final mapped = Map<String, dynamic>.from(raw);
    mapped['match_reason'] ??= _defaultMatchReason(
      (mapped['match_score'] as num?)?.toInt() ?? 0,
    );
    return MatchModel.fromJson(mapped);
  }

  Map<String, dynamic> _defaultMatchReason(int score) => {
        'overall_score': score,
        'skills': {
          'score': (score * 0.5).round(),
          'reason': 'Good skills alignment',
        },
        'work_style': {
          'score': (score * 0.3).round(),
          'reason': 'Work style compatible',
        },
        'experience': {
          'score': (score * 0.2).round(),
          'reason': 'Experience level matches',
        },
        'coaching_tip': 'Highlight your key skills in your application.',
        'match_summary': 'This is a strong match based on your profile.',
      };
}
