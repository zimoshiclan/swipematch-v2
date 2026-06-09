import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    @JsonKey(name: 'post_id') required String postId,
    @JsonKey(name: 'author_id') required String authorId,
    @JsonKey(name: 'author_name') required String authorName,
    @JsonKey(name: 'author_avatar_url') String? authorAvatarUrl,
    @JsonKey(name: 'author_ai_readiness_score') int? authorAiReadinessScore,
    @JsonKey(name: 'parent_id') String? parentId,
    required String content,
    @JsonKey(name: 'likes_count') @Default(0) int likesCount,
    @Default(false) bool isLikedByMe,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
