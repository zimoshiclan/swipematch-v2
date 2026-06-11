// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentModelImpl _$$CommentModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentModelImpl(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      authorAiReadinessScore:
          (json['author_ai_readiness_score'] as num?)?.toInt(),
      parentId: json['parent_id'] as String?,
      content: json['content'] as String,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      isLikedByMe: json['is_liked_by_me'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'author_avatar_url': instance.authorAvatarUrl,
      'author_ai_readiness_score': instance.authorAiReadinessScore,
      'parent_id': instance.parentId,
      'content': instance.content,
      'likes_count': instance.likesCount,
      'is_liked_by_me': instance.isLikedByMe,
      'created_at': instance.createdAt.toIso8601String(),
    };
