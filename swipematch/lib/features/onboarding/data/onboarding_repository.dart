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
    required String? persona,
    required List<String> skills,
    required String status,
    required List<String> connectionIntents,
    required String? city,
    required String? country,
    required String workStyle,
    required List<String> cultureTags,
    required String jobSearchTimeline,
    int? aiReadinessScore,
  }) async {
    final completion = _computeCompletion(
      hasSkills: skills.length >= 3,
      hasLocation: (city != null && city.isNotEmpty) ||
          (country != null && country.isNotEmpty),
      hasWorkStyle: true,
      hasCultureTags: cultureTags.isNotEmpty,
      hasTimeline: true,
      hasAiReadiness: aiReadinessScore != null,
    );

    final updates = <String, dynamic>{
      'persona': persona,
      'skills': skills,
      'passive_mode': status == 'exploring',
      'connection_intents': connectionIntents,
      'city': city,
      'country': country,
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
    required bool hasLocation,
    required bool hasWorkStyle,
    required bool hasCultureTags,
    required bool hasTimeline,
    required bool hasAiReadiness,
  }) {
    int score = 20; // base: name set on account creation
    if (hasSkills) score += 20;
    if (hasLocation) score += 15;
    if (hasWorkStyle) score += 10;
    if (hasCultureTags) score += 10;
    if (hasTimeline) score += 10;
    if (hasAiReadiness) score += 15;
    return score.clamp(0, 100);
  }
}
