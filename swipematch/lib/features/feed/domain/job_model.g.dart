// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobModelImpl _$$JobModelImplFromJson(Map<String, dynamic> json) =>
    _$JobModelImpl(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      requiredSkills: (json['required_skills'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      salaryMin: (json['salary_min'] as num).toInt(),
      salaryMax: (json['salary_max'] as num).toInt(),
      workStyle: json['work_style'] as String,
      experienceYears: (json['experience_years'] as num).toInt(),
      isActive: json['is_active'] as bool? ?? true,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      matchScore: (json['match_score'] as num?)?.toInt() ?? 0,
      matchReasons: (json['match_reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      matchSummary: json['match_summary'] as String?,
      applicantCount: (json['applicant_count'] as num?)?.toInt() ?? 0,
      isHot: json['is_hot'] as bool? ?? false,
      companyName: json['company_name'] as String?,
      companyLogoUrl: json['company_logo_url'] as String?,
      companyColor: json['company_color'] as String?,
      companyGhostScore: (json['company_ghost_score'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$JobModelImplToJson(_$JobModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'title': instance.title,
      'description': instance.description,
      'required_skills': instance.requiredSkills,
      'salary_min': instance.salaryMin,
      'salary_max': instance.salaryMax,
      'work_style': instance.workStyle,
      'experience_years': instance.experienceYears,
      'is_active': instance.isActive,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'match_score': instance.matchScore,
      'match_reasons': instance.matchReasons,
      'match_summary': instance.matchSummary,
      'applicant_count': instance.applicantCount,
      'is_hot': instance.isHot,
      'company_name': instance.companyName,
      'company_logo_url': instance.companyLogoUrl,
      'company_color': instance.companyColor,
      'company_ghost_score': instance.companyGhostScore,
      'created_at': instance.createdAt.toIso8601String(),
    };
