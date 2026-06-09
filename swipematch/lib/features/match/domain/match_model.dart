import 'package:freezed_annotation/freezed_annotation.dart';
import 'match_reason_model.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

@freezed
class MatchModel with _$MatchModel {
  const factory MatchModel({
    required String id,
    required String candidateId,
    required String jobId,
    required String companyId,
    required int matchScore,
    required MatchReasonModel matchReason,
    required String status,
    required DateTime createdAt,
    DateTime? ghostedAt,
    DateTime? firstResponseAt,
    // Joined fields
    String? jobTitle,
    String? companyName,
    String? companyLogoUrl,
    int? companyGhostScore,
    String? candidateName,
    String? candidateAvatarUrl,
    String? candidateVideoPitchUrl,
  }) = _MatchModel;

  factory MatchModel.fromJson(Map<String, dynamic> json) => _$MatchModelFromJson(json);
}
