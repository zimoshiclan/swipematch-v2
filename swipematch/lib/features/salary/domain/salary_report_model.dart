import 'package:freezed_annotation/freezed_annotation.dart';

part 'salary_report_model.freezed.dart';
part 'salary_report_model.g.dart';

@freezed
class SalaryReportModel with _$SalaryReportModel {
  const factory SalaryReportModel({
    required String id,
    String? reporterId,
    required String companyName,
    required String roleTitle,
    required int salary,
    @Default('USD') String currency,
    String? city,
    String? country,
    @Default(false) bool verified,
    required DateTime createdAt,
  }) = _SalaryReportModel;

  factory SalaryReportModel.fromJson(Map<String, dynamic> json) =>
      _$SalaryReportModelFromJson(json);
}

/// Aggregated salary stats for a (company, role) query.
@freezed
class SalaryAggregate with _$SalaryAggregate {
  const factory SalaryAggregate({
    required int count,
    required int min,
    required int max,
    required int median,
    required int p25,
    required int p75,
    @Default('USD') String currency,
    @Default([]) List<SalaryReportModel> sampleReports,
  }) = _SalaryAggregate;

  factory SalaryAggregate.fromJson(Map<String, dynamic> json) =>
      _$SalaryAggregateFromJson(json);
}
