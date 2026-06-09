// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      authorAiReadinessScore:
          (json['author_ai_readiness_score'] as num?)?.toInt(),
      type: json['type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      isLikedByMe: json['is_liked_by_me'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'author_avatar_url': instance.authorAvatarUrl,
      'author_ai_readiness_score': instance.authorAiReadinessScore,
      'type': instance.type,
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
      'likes_count': instance.likesCount,
      'comments_count': instance.commentsCount,
      'is_liked_by_me': instance.isLikedByMe,
      'created_at': instance.createdAt.toIso8601String(),
    };
