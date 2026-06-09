import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/constants/supabase_constants.dart';

class OnboardingRepository {
  OnboardingRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<void> savePartial(String profileId, Map<String, dynamic> fields) async {
    await _supabase
        .from(SupabaseConstants.profiles)
        .update(fields)
        .eq('id', profileId);
  }

  Future<void> saveComplete({
    required String profileId,
    required List<String> skills,
    required String status,
    required int salaryMin,
    required int salaryMax,
    required String currency,
    required String workStyle,
    required List<String> cultureTags,
    required String jobSearchTimeline,
    int? aiReadinessScore,
  }) async {
    final completion = _computeCompletion(
      hasSkills: skills.length >= 3,
      hasSalary: true,
      hasWorkStyle: true,
      hasCultureTags: cultureTags.isNotEmpty,
      hasTimeline: true,
      hasAiReadiness: aiReadinessScore != null,
    );

    final updates = <String, dynamic>{
      'skills': skills,
      'passive_mode': status == 'exploring',
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'currency': currency,
      'work_style': workStyle,
      'culture_tags': cultureTags,
      'job_search_timeline': jobSearchTimeline,
      'profile_completion': completion,
    };
    if (aiReadinessScore != null) {
      updates['ai_readiness_score'] = aiReadinessScore;
    }

    await _supabase
        .from(SupabaseConstants.profiles)
        .update(updates)
        .eq('id', profileId);
  }

  int _computeCompletion({
    required bool hasSkills,
    required bool hasSalary,
    required bool hasWorkStyle,
    required bool hasCultureTags,
    required bool hasTimeline,
    required bool hasAiReadiness,
  }) {
    int score = 20; // base: name set on account creation
    if (hasSkills) score += 20;
    if (hasSalary) score += 15;
    if (hasWorkStyle) score += 10;
    if (hasCultureTags) score += 10;
    if (hasTimeline) score += 10;
    if (hasAiReadiness) score += 15;
    return score.clamp(0, 100);
  }
}
