import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

@freezed
class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    required String id,
    required String employerId,
    required String name,
    String? logoUrl,
    String? size,
    @Default([]) List<String> cultureTags,
    @Default([]) List<String> techStack,
    String? description,
    String? website,
    @Default(100) int ghostScore,
    Map<String, dynamic>? truthScore,
    required DateTime createdAt,
  }) = _CompanyModel;

  factory CompanyModel.fromJson(Map<String, dynamic> json) => _$CompanyModelFromJson(json);
}
