import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String userId,
    required String role,
    required String name,
    String? headline,
    String? avatarUrl,
    String? bio,
    @Default([]) List<String> skills,
    String? persona,
    @Default([]) List<String> connectionIntents,
    String? city,
    String? country,
    String? workStyle,
    @Default([]) List<String> cultureTags,
    int? experienceYears,
    @Default(0) int streakCount,
    DateTime? lastActiveDate,
    @Default(false) bool passiveMode,
    @Default(0) int profileCompletion,
    String? jobSearchTimeline,
    String? videoPitchUrl,
    String? videoPitchTranscript,
    int? aiReadinessScore,
    String? workingToward,
    String? currentlyLearning,
    @Default([]) List<String> workValues,
    required DateTime createdAt,
    // Transient UI-only flag: set by the Room when this card is a serendipity
    // "wildcard" pick. Never read from / written to the database.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isSerendipity,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}
