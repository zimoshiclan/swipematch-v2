// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_reason_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DimensionScoreImpl _$$DimensionScoreImplFromJson(Map<String, dynamic> json) =>
    _$DimensionScoreImpl(
      score: (json['score'] as num).toInt(),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$$DimensionScoreImplToJson(
        _$DimensionScoreImpl instance) =>
    <String, dynamic>{
      'score': instance.score,
      'reason': instance.reason,
    };

_$MatchReasonModelImpl _$$MatchReasonModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MatchReasonModelImpl(
      overallScore: (json['overall_score'] as num).toInt(),
      skills: DimensionScore.fromJson(json['skills'] as Map<String, dynamic>),
      workStyle:
          DimensionScore.fromJson(json['work_style'] as Map<String, dynamic>),
      experience:
          DimensionScore.fromJson(json['experience'] as Map<String, dynamic>),
      coachingTip: json['coaching_tip'] as String,
      matchSummary: json['match_summary'] as String,
    );

Map<String, dynamic> _$$MatchReasonModelImplToJson(
        _$MatchReasonModelImpl instance) =>
    <String, dynamic>{
      'overall_score': instance.overallScore,
      'skills': instance.skills.toJson(),
      'work_style': instance.workStyle.toJson(),
      'experience': instance.experience.toJson(),
      'coaching_tip': instance.coachingTip,
      'match_summary': instance.matchSummary,
    };
