// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileModelImpl _$$ProfileModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfileModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      name: json['name'] as String,
      headline: json['headline'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      persona: json['persona'] as String?,
      connectionIntents: (json['connection_intents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      city: json['city'] as String?,
      country: json['country'] as String?,
      workStyle: json['work_style'] as String?,
      cultureTags: (json['culture_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      experienceYears: (json['experience_years'] as num?)?.toInt(),
      streakCount: (json['streak_count'] as num?)?.toInt() ?? 0,
      lastActiveDate: json['last_active_date'] == null
          ? null
          : DateTime.parse(json['last_active_date'] as String),
      passiveMode: json['passive_mode'] as bool? ?? false,
      profileCompletion: (json['profile_completion'] as num?)?.toInt() ?? 0,
      jobSearchTimeline: json['job_search_timeline'] as String?,
      videoPitchUrl: json['video_pitch_url'] as String?,
      videoPitchTranscript: json['video_pitch_transcript'] as String?,
      aiReadinessScore: (json['ai_readiness_score'] as num?)?.toInt(),
      workingToward: json['working_toward'] as String?,
      currentlyLearning: json['currently_learning'] as String?,
      workValues: (json['work_values'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ProfileModelImplToJson(_$ProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'role': instance.role,
      'name': instance.name,
      'headline': instance.headline,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
      'skills': instance.skills,
      'persona': instance.persona,
      'connection_intents': instance.connectionIntents,
      'city': instance.city,
      'country': instance.country,
      'work_style': instance.workStyle,
      'culture_tags': instance.cultureTags,
      'experience_years': instance.experienceYears,
      'streak_count': instance.streakCount,
      'last_active_date': instance.lastActiveDate?.toIso8601String(),
      'passive_mode': instance.passiveMode,
      'profile_completion': instance.profileCompletion,
      'job_search_timeline': instance.jobSearchTimeline,
      'video_pitch_url': instance.videoPitchUrl,
      'video_pitch_transcript': instance.videoPitchTranscript,
      'ai_readiness_score': instance.aiReadinessScore,
      'working_toward': instance.workingToward,
      'currently_learning': instance.currentlyLearning,
      'work_values': instance.workValues,
      'created_at': instance.createdAt.toIso8601String(),
    };
