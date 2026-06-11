import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/onboarding_repository.dart';
import '../domain/onboarding_state.dart';
import '../../profile/domain/profile_providers.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(Supabase.instance.client);
});

final onboardingNotifierProvider =
    AutoDisposeNotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);

class OnboardingNotifier extends AutoDisposeNotifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void nextPage() => state = state.copyWith(currentPage: state.currentPage + 1);
  void prevPage() => state = state.copyWith(currentPage: state.currentPage - 1);

  void addSkill(String skill) {
    if (state.skills.contains(skill)) return;
    state = state.copyWith(skills: [...state.skills, skill]);
  }

  void removeSkill(String skill) {
    state = state.copyWith(
        skills: state.skills.where((s) => s != skill).toList());
  }

  void setStatus(String status) => state = state.copyWith(status: status);

  void setPersona(String persona) => state = state.copyWith(persona: persona);

  void toggleConnectionIntent(String intent) {
    final intents = List<String>.from(state.connectionIntents);
    intents.contains(intent) ? intents.remove(intent) : intents.add(intent);
    state = state.copyWith(connectionIntents: intents);
  }

  void setCity(String city) => state = state.copyWith(city: city);
  void setCountry(String country) => state = state.copyWith(country: country);

  void setWorkStyle(String style) => state = state.copyWith(workStyle: style);

  void toggleCultureTag(String tag) {
    final tags = List<String>.from(state.cultureTags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else if (tags.length < 5) {
      tags.add(tag);
    }
    state = state.copyWith(cultureTags: tags);
  }

  void setTimeline(String timeline) =>
      state = state.copyWith(jobSearchTimeline: timeline);

  void setAiReadinessAnswer(String questionId, int score) {
    state = state.copyWith(
      aiReadinessAnswers: {...state.aiReadinessAnswers, questionId: score},
    );
  }

  int get computedAiReadinessScore =>
      state.aiReadinessAnswers.values.fold(0, (a, b) => a + b);

  Future<void> saveBecoming(
    String profileId, {
    required String? workingToward,
    required List<String> workValues,
  }) async {
    final repo = ref.read(onboardingRepositoryProvider);
    await repo.savePartial(profileId, {
      'working_toward':
          (workingToward?.isEmpty ?? true) ? null : workingToward,
      'work_values': workValues,
    });
  }

  Future<void> savePageToSupabase(String profileId, int page) async {
    final repo = ref.read(onboardingRepositoryProvider);
    switch (page) {
      case 0:
        await repo.savePartial(profileId, {'persona': state.persona});
      case 1:
        await repo.savePartial(profileId, {'skills': state.skills});
      // page 2 (Becoming) is saved via saveBecoming() before advance
      case 3:
        await repo.savePartial(profileId, {
          'passive_mode': state.status == 'investing_in_growth',
        });
      case 4:
        await repo.savePartial(profileId, {
          'connection_intents': state.connectionIntents,
          'city': (state.city?.trim().isEmpty ?? true) ? null : state.city!.trim(),
          'country':
              (state.country?.trim().isEmpty ?? true) ? null : state.country!.trim(),
        });
    }
  }

  Future<void> completeOnboarding(String profileId) async {
    final repo = ref.read(onboardingRepositoryProvider);
    // Map the community-framed status values back to DB values
    final dbStatus = switch (state.status) {
      'investing_in_growth' => 'exploring',
      'open' => 'open',
      String s => s,
      null => 'actively_looking',
    };
    await repo.saveComplete(
      profileId: profileId,
      persona: state.persona,
      skills: state.skills,
      status: dbStatus,
      connectionIntents: state.connectionIntents,
      city: (state.city?.trim().isEmpty ?? true) ? null : state.city!.trim(),
      country:
          (state.country?.trim().isEmpty ?? true) ? null : state.country!.trim(),
      workStyle: state.workStyle ?? 'remote',
      cultureTags: state.cultureTags,
      jobSearchTimeline: state.jobSearchTimeline ?? 'exploring',
      aiReadinessScore: computedAiReadinessScore > 0
          ? computedAiReadinessScore
          : null,
    );
    ref.invalidate(currentProfileProvider);
  }
}
