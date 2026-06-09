import 'package:freezed_annotation/freezed_annotation.dart';

part 'candidate_card_model.freezed.dart';
part 'candidate_card_model.g.dart';

@freezed
class CandidateCardModel with _$CandidateCardModel {
  const factory CandidateCardModel({
    required String id,
    required String name,
    String? avatarUrl,
    String? headline,
    required List<String> skills,
    required int experienceYears,
    required String workStyle,
    @Default(0) int matchScore,
    @Default([]) List<String> matchReasons,
    String? videoPitchUrl,
    required DateTime createdAt,
  }) = _CandidateCardModel;

  factory CandidateCardModel.fromJson(Map<String, dynamic> json) =>
      _$CandidateCardModelFromJson(json);
}
