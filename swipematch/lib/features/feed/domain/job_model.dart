import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

@freezed
class JobModel with _$JobModel {
  const factory JobModel({
    required String id,
    required String companyId,
    required String title,
    required String description,
    required List<String> requiredSkills,
    required int salaryMin,
    required int salaryMax,
    required String workStyle,
    required int experienceYears,
    @Default(true) bool isActive,
    DateTime? expiresAt,
    // Computed fields from Edge Function
    @Default(0) int matchScore,
    @Default([]) List<String> matchReasons,
    String? matchSummary,
    // Social proof
    @Default(0) int applicantCount,
    @Default(false) bool isHot,
    // Company info joined
    String? companyName,
    String? companyLogoUrl,
    String? companyColor,
    int? companyGhostScore,
    required DateTime createdAt,
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);
}
