import 'package:freezed_annotation/freezed_annotation.dart';

part 'swipe_model.freezed.dart';
part 'swipe_model.g.dart';

@freezed
class SwipeModel with _$SwipeModel {
  const factory SwipeModel({
    required String id,
    required String userId,
    required String targetId,
    required String targetType,
    required String direction,
    required DateTime createdAt,
  }) = _SwipeModel;

  factory SwipeModel.fromJson(Map<String, dynamic> json) => _$SwipeModelFromJson(json);
}
