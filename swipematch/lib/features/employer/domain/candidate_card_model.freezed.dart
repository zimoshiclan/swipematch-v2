// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'candidate_card_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CandidateCardModel _$CandidateCardModelFromJson(Map<String, dynamic> json) {
  return _CandidateCardModel.fromJson(json);
}

/// @nodoc
mixin _$CandidateCardModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get headline => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  int get experienceYears => throw _privateConstructorUsedError;
  String get workStyle => throw _privateConstructorUsedError;
  int get matchScore => throw _privateConstructorUsedError;
  List<String> get matchReasons => throw _privateConstructorUsedError;
  String? get videoPitchUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CandidateCardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CandidateCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CandidateCardModelCopyWith<CandidateCardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandidateCardModelCopyWith<$Res> {
  factory $CandidateCardModelCopyWith(
          CandidateCardModel value, $Res Function(CandidateCardModel) then) =
      _$CandidateCardModelCopyWithImpl<$Res, CandidateCardModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? avatarUrl,
      String? headline,
      List<String> skills,
      int experienceYears,
      String workStyle,
      int matchScore,
      List<String> matchReasons,
      String? videoPitchUrl,
      DateTime createdAt});
}

/// @nodoc
class _$CandidateCardModelCopyWithImpl<$Res, $Val extends CandidateCardModel>
    implements $CandidateCardModelCopyWith<$Res> {
  _$CandidateCardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CandidateCardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? headline = freezed,
    Object? skills = null,
    Object? experienceYears = null,
    Object? workStyle = null,
    Object? matchScore = null,
    Object? matchReasons = null,
    Object? videoPitchUrl = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      headline: freezed == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String?,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      workStyle: null == workStyle
          ? _value.workStyle
          : workStyle // ignore: cast_nullable_to_non_nullable
              as String,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      matchReasons: null == matchReasons
          ? _value.matchReasons
          : matchReasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoPitchUrl: freezed == videoPitchUrl
          ? _value.videoPitchUrl
          : videoPitchUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CandidateCardModelImplCopyWith<$Res>
    implements $CandidateCardModelCopyWith<$Res> {
  factory _$$CandidateCardModelImplCopyWith(_$CandidateCardModelImpl value,
          $Res Function(_$CandidateCardModelImpl) then) =
      __$$CandidateCardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? avatarUrl,
      String? headline,
      List<String> skills,
      int experienceYears,
      String workStyle,
      int matchScore,
      List<String> matchReasons,
      String? videoPitchUrl,
      DateTime createdAt});
}

/// @nodoc
class __$$CandidateCardModelImplCopyWithImpl<$Res>
    extends _$CandidateCardModelCopyWithImpl<$Res, _$CandidateCardModelImpl>
    implements _$$CandidateCardModelImplCopyWith<$Res> {
  __$$CandidateCardModelImplCopyWithImpl(_$CandidateCardModelImpl _value,
      $Res Function(_$CandidateCardModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CandidateCardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? headline = freezed,
    Object? skills = null,
    Object? experienceYears = null,
    Object? workStyle = null,
    Object? matchScore = null,
    Object? matchReasons = null,
    Object? videoPitchUrl = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$CandidateCardModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      headline: freezed == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String?,
      skills: null == skills
          ? _value._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      workStyle: null == workStyle
          ? _value.workStyle
          : workStyle // ignore: cast_nullable_to_non_nullable
              as String,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      matchReasons: null == matchReasons
          ? _value._matchReasons
          : matchReasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoPitchUrl: freezed == videoPitchUrl
          ? _value.videoPitchUrl
          : videoPitchUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CandidateCardModelImpl implements _CandidateCardModel {
  const _$CandidateCardModelImpl(
      {required this.id,
      required this.name,
      this.avatarUrl,
      this.headline,
      required final List<String> skills,
      required this.experienceYears,
      required this.workStyle,
      this.matchScore = 0,
      final List<String> matchReasons = const [],
      this.videoPitchUrl,
      required this.createdAt})
      : _skills = skills,
        _matchReasons = matchReasons;

  factory _$CandidateCardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CandidateCardModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? avatarUrl;
  @override
  final String? headline;
  final List<String> _skills;
  @override
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  @override
  final int experienceYears;
  @override
  final String workStyle;
  @override
  @JsonKey()
  final int matchScore;
  final List<String> _matchReasons;
  @override
  @JsonKey()
  List<String> get matchReasons {
    if (_matchReasons is EqualUnmodifiableListView) return _matchReasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matchReasons);
  }

  @override
  final String? videoPitchUrl;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CandidateCardModel(id: $id, name: $name, avatarUrl: $avatarUrl, headline: $headline, skills: $skills, experienceYears: $experienceYears, workStyle: $workStyle, matchScore: $matchScore, matchReasons: $matchReasons, videoPitchUrl: $videoPitchUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CandidateCardModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.workStyle, workStyle) ||
                other.workStyle == workStyle) &&
            (identical(other.matchScore, matchScore) ||
                other.matchScore == matchScore) &&
            const DeepCollectionEquality()
                .equals(other._matchReasons, _matchReasons) &&
            (identical(other.videoPitchUrl, videoPitchUrl) ||
                other.videoPitchUrl == videoPitchUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      avatarUrl,
      headline,
      const DeepCollectionEquality().hash(_skills),
      experienceYears,
      workStyle,
      matchScore,
      const DeepCollectionEquality().hash(_matchReasons),
      videoPitchUrl,
      createdAt);

  /// Create a copy of CandidateCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CandidateCardModelImplCopyWith<_$CandidateCardModelImpl> get copyWith =>
      __$$CandidateCardModelImplCopyWithImpl<_$CandidateCardModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CandidateCardModelImplToJson(
      this,
    );
  }
}

abstract class _CandidateCardModel implements CandidateCardModel {
  const factory _CandidateCardModel(
      {required final String id,
      required final String name,
      final String? avatarUrl,
      final String? headline,
      required final List<String> skills,
      required final int experienceYears,
      required final String workStyle,
      final int matchScore,
      final List<String> matchReasons,
      final String? videoPitchUrl,
      required final DateTime createdAt}) = _$CandidateCardModelImpl;

  factory _CandidateCardModel.fromJson(Map<String, dynamic> json) =
      _$CandidateCardModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get avatarUrl;
  @override
  String? get headline;
  @override
  List<String> get skills;
  @override
  int get experienceYears;
  @override
  String get workStyle;
  @override
  int get matchScore;
  @override
  List<String> get matchReasons;
  @override
  String? get videoPitchUrl;
  @override
  DateTime get createdAt;

  /// Create a copy of CandidateCardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CandidateCardModelImplCopyWith<_$CandidateCardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
