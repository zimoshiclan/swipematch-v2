// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candidate_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CandidateCardModelImpl _$$CandidateCardModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CandidateCardModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      headline: json['headline'] as String?,
      skills:
          (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
      experienceYears: (json['experience_years'] as num).toInt(),
      workStyle: json['work_style'] as String,
      matchScore: (json['match_score'] as num?)?.toInt() ?? 0,
      matchReasons: (json['match_reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videoPitchUrl: json['video_pitch_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$CandidateCardModelImplToJson(
        _$CandidateCardModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'headline': instance.headline,
      'skills': instance.skills,
      'experience_years': instance.experienceYears,
      'work_style': instance.workStyle,
      'match_score': instance.matchScore,
      'match_reasons': instance.matchReasons,
      'video_pitch_url': instance.videoPitchUrl,
      'created_at': instance.createdAt.toIso8601String(),
    };
