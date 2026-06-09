// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swipe_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SwipeModel _$SwipeModelFromJson(Map<String, dynamic> json) {
  return _SwipeModel.fromJson(json);
}

/// @nodoc
mixin _$SwipeModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get targetId => throw _privateConstructorUsedError;
  String get targetType => throw _privateConstructorUsedError;
  String get direction => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SwipeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SwipeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwipeModelCopyWith<SwipeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwipeModelCopyWith<$Res> {
  factory $SwipeModelCopyWith(
          SwipeModel value, $Res Function(SwipeModel) then) =
      _$SwipeModelCopyWithImpl<$Res, SwipeModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String targetId,
      String targetType,
      String direction,
      DateTime createdAt});
}

/// @nodoc
class _$SwipeModelCopyWithImpl<$Res, $Val extends SwipeModel>
    implements $SwipeModelCopyWith<$Res> {
  _$SwipeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SwipeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? targetId = null,
    Object? targetType = null,
    Object? direction = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      targetType: null == targetType
          ? _value.targetType
          : targetType // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SwipeModelImplCopyWith<$Res>
    implements $SwipeModelCopyWith<$Res> {
  factory _$$SwipeModelImplCopyWith(
          _$SwipeModelImpl value, $Res Function(_$SwipeModelImpl) then) =
      __$$SwipeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String targetId,
      String targetType,
      String direction,
      DateTime createdAt});
}

/// @nodoc
class __$$SwipeModelImplCopyWithImpl<$Res>
    extends _$SwipeModelCopyWithImpl<$Res, _$SwipeModelImpl>
    implements _$$SwipeModelImplCopyWith<$Res> {
  __$$SwipeModelImplCopyWithImpl(
      _$SwipeModelImpl _value, $Res Function(_$SwipeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SwipeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? targetId = null,
    Object? targetType = null,
    Object? direction = null,
    Object? createdAt = null,
  }) {
    return _then(_$SwipeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      targetType: null == targetType
          ? _value.targetType
          : targetType // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SwipeModelImpl implements _SwipeModel {
  const _$SwipeModelImpl(
      {required this.id,
      required this.userId,
      required this.targetId,
      required this.targetType,
      required this.direction,
      required this.createdAt});

  factory _$SwipeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwipeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String targetId;
  @override
  final String targetType;
  @override
  final String direction;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SwipeModel(id: $id, userId: $userId, targetId: $targetId, targetType: $targetType, direction: $direction, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwipeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.targetType, targetType) ||
                other.targetType == targetType) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, targetId, targetType, direction, createdAt);

  /// Create a copy of SwipeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwipeModelImplCopyWith<_$SwipeModelImpl> get copyWith =>
      __$$SwipeModelImplCopyWithImpl<_$SwipeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwipeModelImplToJson(
      this,
    );
  }
}

abstract class _SwipeModel implements SwipeModel {
  const factory _SwipeModel(
      {required final String id,
      required final String userId,
      required final String targetId,
      required final String targetType,
      required final String direction,
      required final DateTime createdAt}) = _$SwipeModelImpl;

  factory _SwipeModel.fromJson(Map<String, dynamic> json) =
      _$SwipeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get targetId;
  @override
  String get targetType;
  @override
  String get direction;
  @override
  DateTime get createdAt;

  /// Create a copy of SwipeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwipeModelImplCopyWith<_$SwipeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
