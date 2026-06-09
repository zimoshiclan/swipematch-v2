// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchModelImpl _$$MatchModelImplFromJson(Map<String, dynamic> json) =>
    _$MatchModelImpl(
      id: json['id'] as String,
      candidateId: json['candidate_id'] as String,
      jobId: json['job_id'] as String,
      companyId: json['company_id'] as String,
      matchScore: (json['match_score'] as num).toInt(),
      matchReason: MatchReasonModel.fromJson(
          json['match_reason'] as Map<String, dynamic>),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      ghostedAt: json['ghosted_at'] == null
          ? null
          : DateTime.parse(json['ghosted_at'] as String),
      firstResponseAt: json['first_response_at'] == null
          ? null
          : DateTime.parse(json['first_response_at'] as String),
      jobTitle: json['job_title'] as String?,
      companyName: json['company_name'] as String?,
      companyLogoUrl: json['company_logo_url'] as String?,
      companyGhostScore: (json['company_ghost_score'] as num?)?.toInt(),
      candidateName: json['candidate_name'] as String?,
      candidateAvatarUrl: json['candidate_avatar_url'] as String?,
      candidateVideoPitchUrl: json['candidate_video_pitch_url'] as String?,
    );

Map<String, dynamic> _$$MatchModelImplToJson(_$MatchModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'candidate_id': instance.candidateId,
      'job_id': instance.jobId,
      'company_id': instance.companyId,
      'match_score': instance.matchScore,
      'match_reason': instance.matchReason.toJson(),
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'ghosted_at': instance.ghostedAt?.toIso8601String(),
      'first_response_at': instance.firstResponseAt?.toIso8601String(),
      'job_title': instance.jobTitle,
      'company_name': instance.companyName,
      'company_logo_url': instance.companyLogoUrl,
      'company_ghost_score': instance.companyGhostScore,
      'candidate_name': instance.candidateName,
      'candidate_avatar_url': instance.candidateAvatarUrl,
      'candidate_video_pitch_url': instance.candidateVideoPitchUrl,
    };
