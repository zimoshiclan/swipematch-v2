import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_reason_model.freezed.dart';
part 'match_reason_model.g.dart';

@freezed
class DimensionScore with _$DimensionScore {
  const factory DimensionScore({
    required int score,
    required String reason,
  }) = _DimensionScore;

  factory DimensionScore.fromJson(Map<String, dynamic> json) => _$DimensionScoreFromJson(json);
}

@freezed
class MatchReasonModel with _$MatchReasonModel {
  const factory MatchReasonModel({
    required int overallScore,
    required DimensionScore skills,
    required DimensionScore salary,
    required DimensionScore workStyle,
    required DimensionScore experience,
    required String coachingTip,
    required String matchSummary,
  }) = _MatchReasonModel;

  factory MatchReasonModel.fromJson(Map<String, dynamic> json) => _$MatchReasonModelFromJson(json);
}
