import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int currentPage,
    @Default([]) List<String> skills,
    String? status,
    // Open-networking fields (replaces the candidate/employer + salary model)
    String? persona,
    @Default([]) List<String> connectionIntents,
    String? city,
    String? country,
    String? workingToward,
    String? currentlyLearning,
    String? workStyle,
    @Default([]) List<String> cultureTags,
    @Default([]) List<String> workValues,
    String? jobSearchTimeline,
    // question_id → selected score (0–20 each, 5 questions = 100 max)
    @Default({}) Map<String, int> aiReadinessAnswers,
  }) = _OnboardingState;
}
