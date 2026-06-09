import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String authorId,
    @JsonKey(name: 'author_name') required String authorName,
    @JsonKey(name: 'author_avatar_url') String? authorAvatarUrl,
    @JsonKey(name: 'author_ai_readiness_score') int? authorAiReadinessScore,
    required String type,
    required String title,
    required String content,
    @JsonKey(name: 'media_url') String? mediaUrl,
    @JsonKey(name: 'media_type') String? mediaType,
    @Default([]) List<String> tags,
    @JsonKey(name: 'likes_count') @Default(0) int likesCount,
    @JsonKey(name: 'comments_count') @Default(0) int commentsCount,
    @Default(false) bool isLikedByMe,
    @Default(false) bool isBookmarkedByMe,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
