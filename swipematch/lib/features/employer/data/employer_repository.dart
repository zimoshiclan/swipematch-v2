// ignore_for_file: unused_field
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/candidate_card_model.dart';
import '../../match/domain/match_model.dart';
import '../../../shared/constants/supabase_constants.dart';

class EmployerRepository {
  EmployerRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<String?> fetchCompanyId(String employerProfileId) async {
    final result = await _supabase
        .from(SupabaseConstants.companies)
        .select('id')
        .eq('employer_id', employerProfileId)
        .maybeSingle();
    return result?['id'] as String?;
  }

  Future<List<CandidateCardModel>> fetchCandidateDeck({
    required String employerProfileId,  // profile UUID — for company/jobs lookup
    required String employerUserId,     // auth user UUID — for swipes RLS
  }) async {
    final companyId = await fetchCompanyId(employerProfileId);
    if (companyId == null) return [];

    // Jobs from this company
    final jobs = await _supabase
        .from(SupabaseConstants.jobs)
        .select('id')
        .eq('company_id', companyId);

    final jobIds = (jobs as List).map((j) => j['id'] as String).toList();
    if (jobIds.isEmpty) return [];

    // Candidates who right-swiped these jobs; user_id = auth user UUID
    final applications = await _supabase
        .from(SupabaseConstants.swipes)
        .select('user_id')
        .inFilter('target_id', jobIds)
        .eq('target_type', 'job')
        .neq('direction', 'left');

    // swipes.user_id stores auth user UUIDs → filter profiles by user_id
    final candidateUserIds = (applications as List)
        .map((s) => s['user_id'] as String)
        .toSet()
        .toList();
    if (candidateUserIds.isEmpty) return [];

    // Already reviewed by this employer (target_id = candidate profile UUID)
    final reviewed = await _supabase
        .from(SupabaseConstants.swipes)
        .select('target_id')
        .eq('user_id', employerUserId)  // auth user UUID
        .eq('target_type', 'candidate');

    final reviewedIds =
        (reviewed as List).map((r) => r['target_id'] as String).toSet();

    // Fetch candidate profiles by user_id (auth UUID → profile row)
    final profiles = await _supabase
        .from(SupabaseConstants.profiles)
        .select()
        .inFilter('user_id', candidateUserIds)  // auth user UUID → profile
        .eq('role', 'candidate')
        .limit(15);

    return (profiles as List)
        .where((p) => !reviewedIds.contains(p['id'] as String))
        .map((p) {
      final skills = List<String>.from(
        (p['skills'] as List? ?? []).map((s) => s as String),
      );
      return CandidateCardModel(
        id: p['id'] as String,
        name: p['name'] as String,
        avatarUrl: p['avatar_url'] as String?,
        headline: p['bio'] as String? ?? _deriveHeadline(skills, p['experience_years'] as int?),
        skills: skills,
        experienceYears: (p['experience_years'] as int?) ?? 0,
        workStyle: (p['work_style'] as String?) ?? 'remote',
        videoPitchUrl: p['video_pitch_url'] as String?,
        createdAt: DateTime.parse(p['created_at'] as String),
      );
    }).toList();
  }

  Future<void> recordCandidateSwipe({
    required String employerUserId,  // auth user UUID — satisfies FK + RLS
    required String candidateId,
    required String direction,
  }) async {
    await _supabase.from(SupabaseConstants.swipes).insert({
      'user_id': employerUserId,
      'target_id': candidateId,
      'target_type': 'candidate',
      'direction': direction,
    });
  }

  Future<List<MatchModel>> fetchPipelineMatches(String companyId) async {
    final response = await _supabase
        .from(SupabaseConstants.matches)
        .select()
        .eq('company_id', companyId)
        .order('created_at', ascending: false);

    return Future.wait((response as List).map((m) async {
      final jobData = await _supabase
          .from(SupabaseConstants.jobs)
          .select('title')
          .eq('id', m['job_id'] as String)
          .maybeSingle();

      final candidateData = await _supabase
          .from(SupabaseConstants.profiles)
          .select('name, avatar_url, video_pitch_url')
          .eq('id', m['candidate_id'] as String)
          .maybeSingle();

      final mapped = Map<String, dynamic>.from(m);
      mapped['job_title'] = jobData?['title'];
      mapped['candidate_name'] = candidateData?['name'];
      mapped['candidate_avatar_url'] = candidateData?['avatar_url'];
      mapped['candidate_video_pitch_url'] = candidateData?['video_pitch_url'];
      mapped['match_reason'] ??= _defaultReason((m['match_score'] as num?)?.toInt() ?? 0);

      return MatchModel.fromJson(mapped);
    }));
  }

  Future<void> updateMatchStatus(String matchId, String status) async {
    await _supabase
        .from(SupabaseConstants.matches)
        .update({'status': status}).eq('id', matchId);
  }

  String _deriveHeadline(List<String> skills, int? years) {
    if (skills.isEmpty) return 'Professional';
    final role = skills.first;
    return years != null && years > 0 ? '$years yr $role' : '$role Developer';
  }

  Map<String, dynamic> _defaultReason(int score) => {
        'overall_score': score,
        'skills': {'score': (score * 0.5).round(), 'reason': 'Skills align'},
        'work_style': {'score': (score * 0.3).round(), 'reason': 'Style matches'},
        'experience': {'score': (score * 0.2).round(), 'reason': 'Experience ok'},
        'coaching_tip': '',
        'match_summary': '',
      };
}
