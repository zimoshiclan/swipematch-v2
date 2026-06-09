import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int currentPage,
    @Default([]) List<String> selectedRoles,
    @Default([]) List<String> skills,
    String? status,
    int? salaryMin,
    int? salaryMax,
    String? workStyle,
    @Default([]) List<String> cultureTags,
    String? jobSearchTimeline,
    // question_id → selected score (0–20 each, 5 questions = 100 max)
    @Default({}) Map<String, int> aiReadinessAnswers,
  }) = _OnboardingState;
}
