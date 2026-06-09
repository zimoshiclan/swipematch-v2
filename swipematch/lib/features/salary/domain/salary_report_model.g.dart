// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalaryReportModelImpl _$$SalaryReportModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SalaryReportModelImpl(
      id: json['id'] as String,
      reporterId: json['reporter_id'] as String?,
      companyName: json['company_name'] as String,
      roleTitle: json['role_title'] as String,
      salary: (json['salary'] as num).toInt(),
      currency: json['currency'] as String? ?? 'USD',
      city: json['city'] as String?,
      country: json['country'] as String?,
      verified: json['verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$SalaryReportModelImplToJson(
        _$SalaryReportModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporter_id': instance.reporterId,
      'company_name': instance.companyName,
      'role_title': instance.roleTitle,
      'salary': instance.salary,
      'currency': instance.currency,
      'city': instance.city,
      'country': instance.country,
      'verified': instance.verified,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$SalaryAggregateImpl _$$SalaryAggregateImplFromJson(
        Map<String, dynamic> json) =>
    _$SalaryAggregateImpl(
      count: (json['count'] as num).toInt(),
      min: (json['min'] as num).toInt(),
      max: (json['max'] as num).toInt(),
      median: (json['median'] as num).toInt(),
      p25: (json['p25'] as num).toInt(),
      p75: (json['p75'] as num).toInt(),
      currency: json['currency'] as String? ?? 'USD',
      sampleReports: (json['sample_reports'] as List<dynamic>?)
              ?.map(
                  (e) => SalaryReportModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SalaryAggregateImplToJson(
        _$SalaryAggregateImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'min': instance.min,
      'max': instance.max,
      'median': instance.median,
      'p25': instance.p25,
      'p75': instance.p75,
      'currency': instance.currency,
      'sample_reports': instance.sampleReports.map((e) => e.toJson()).toList(),
    };
