// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyModelImpl _$$CompanyModelImplFromJson(Map<String, dynamic> json) =>
    _$CompanyModelImpl(
      id: json['id'] as String,
      employerId: json['employer_id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      size: json['size'] as String?,
      cultureTags: (json['culture_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      techStack: (json['tech_stack'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String?,
      website: json['website'] as String?,
      ghostScore: (json['ghost_score'] as num?)?.toInt() ?? 100,
      truthScore: json['truth_score'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$CompanyModelImplToJson(_$CompanyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employer_id': instance.employerId,
      'name': instance.name,
      'logo_url': instance.logoUrl,
      'size': instance.size,
      'culture_tags': instance.cultureTags,
      'tech_stack': instance.techStack,
      'description': instance.description,
      'website': instance.website,
      'ghost_score': instance.ghostScore,
      'truth_score': instance.truthScore,
      'created_at': instance.createdAt.toIso8601String(),
    };
