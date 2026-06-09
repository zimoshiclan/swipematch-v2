// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SwipeModelImpl _$$SwipeModelImplFromJson(Map<String, dynamic> json) =>
    _$SwipeModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      targetId: json['target_id'] as String,
      targetType: json['target_type'] as String,
      direction: json['direction'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$SwipeModelImplToJson(_$SwipeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'target_id': instance.targetId,
      'target_type': instance.targetType,
      'direction': instance.direction,
      'created_at': instance.createdAt.toIso8601String(),
    };
