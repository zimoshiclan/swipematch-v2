// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_reason_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DimensionScore _$DimensionScoreFromJson(Map<String, dynamic> json) {
  return _DimensionScore.fromJson(json);
}

/// @nodoc
mixin _$DimensionScore {
  int get score => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;

  /// Serializes this DimensionScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DimensionScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DimensionScoreCopyWith<DimensionScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DimensionScoreCopyWith<$Res> {
  factory $DimensionScoreCopyWith(
          DimensionScore value, $Res Function(DimensionScore) then) =
      _$DimensionScoreCopyWithImpl<$Res, DimensionScore>;
  @useResult
  $Res call({int score, String reason});
}

/// @nodoc
class _$DimensionScoreCopyWithImpl<$Res, $Val extends DimensionScore>
    implements $DimensionScoreCopyWith<$Res> {
  _$DimensionScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DimensionScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? reason = null,
  }) {
    return _then(_value.copyWith(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DimensionScoreImplCopyWith<$Res>
    implements $DimensionScoreCopyWith<$Res> {
  factory _$$DimensionScoreImplCopyWith(_$DimensionScoreImpl value,
          $Res Function(_$DimensionScoreImpl) then) =
      __$$DimensionScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int score, String reason});
}

/// @nodoc
class __$$DimensionScoreImplCopyWithImpl<$Res>
    extends _$DimensionScoreCopyWithImpl<$Res, _$DimensionScoreImpl>
    implements _$$DimensionScoreImplCopyWith<$Res> {
  __$$DimensionScoreImplCopyWithImpl(
      _$DimensionScoreImpl _value, $Res Function(_$DimensionScoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of DimensionScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? reason = null,
  }) {
    return _then(_$DimensionScoreImpl(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DimensionScoreImpl implements _DimensionScore {
  const _$DimensionScoreImpl({required this.score, required this.reason});

  factory _$DimensionScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$DimensionScoreImplFromJson(json);

  @override
  final int score;
  @override
  final String reason;

  @override
  String toString() {
    return 'DimensionScore(score: $score, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DimensionScoreImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, score, reason);

  /// Create a copy of DimensionScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DimensionScoreImplCopyWith<_$DimensionScoreImpl> get copyWith =>
      __$$DimensionScoreImplCopyWithImpl<_$DimensionScoreImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DimensionScoreImplToJson(
      this,
    );
  }
}

abstract class _DimensionScore implements DimensionScore {
  const factory _DimensionScore(
      {required final int score,
      required final String reason}) = _$DimensionScoreImpl;

  factory _DimensionScore.fromJson(Map<String, dynamic> json) =
      _$DimensionScoreImpl.fromJson;

  @override
  int get score;
  @override
  String get reason;

  /// Create a copy of DimensionScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DimensionScoreImplCopyWith<_$DimensionScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchReasonModel _$MatchReasonModelFromJson(Map<String, dynamic> json) {
  return _MatchReasonModel.fromJson(json);
}

/// @nodoc
mixin _$MatchReasonModel {
  int get overallScore => throw _privateConstructorUsedError;
  DimensionScore get skills => throw _privateConstructorUsedError;
  DimensionScore get workStyle => throw _privateConstructorUsedError;
  DimensionScore get experience => throw _privateConstructorUsedError;
  String get coachingTip => throw _privateConstructorUsedError;
  String get matchSummary => throw _privateConstructorUsedError;

  /// Serializes this MatchReasonModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchReasonModelCopyWith<MatchReasonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchReasonModelCopyWith<$Res> {
  factory $MatchReasonModelCopyWith(
          MatchReasonModel value, $Res Function(MatchReasonModel) then) =
      _$MatchReasonModelCopyWithImpl<$Res, MatchReasonModel>;
  @useResult
  $Res call(
      {int overallScore,
      DimensionScore skills,
      DimensionScore workStyle,
      DimensionScore experience,
      String coachingTip,
      String matchSummary});

  $DimensionScoreCopyWith<$Res> get skills;
  $DimensionScoreCopyWith<$Res> get workStyle;
  $DimensionScoreCopyWith<$Res> get experience;
}

/// @nodoc
class _$MatchReasonModelCopyWithImpl<$Res, $Val extends MatchReasonModel>
    implements $MatchReasonModelCopyWith<$Res> {
  _$MatchReasonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overallScore = null,
    Object? skills = null,
    Object? workStyle = null,
    Object? experience = null,
    Object? coachingTip = null,
    Object? matchSummary = null,
  }) {
    return _then(_value.copyWith(
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as int,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as DimensionScore,
      workStyle: null == workStyle
          ? _value.workStyle
          : workStyle // ignore: cast_nullable_to_non_nullable
              as DimensionScore,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as DimensionScore,
      coachingTip: null == coachingTip
          ? _value.coachingTip
          : coachingTip // ignore: cast_nullable_to_non_nullable
              as String,
      matchSummary: null == matchSummary
          ? _value.matchSummary
          : matchSummary // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of MatchReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DimensionScoreCopyWith<$Res> get skills {
    return $DimensionScoreCopyWith<$Res>(_value.skills, (value) {
      return _then(_value.copyWith(skills: value) as $Val);
    });
  }

  /// Create a copy of MatchReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DimensionScoreCopyWith<$Res> get workStyle {
    return $DimensionScoreCopyWith<$Res>(_value.workStyle, (value) {
      return _then(_value.copyWith(workStyle: value) as $Val);
    });
  }

  /// Create a copy of MatchReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DimensionScoreCopyWith<$Res> get experience {
    return $DimensionScoreCopyWith<$Res>(_value.experience, (value) {
      return _then(_value.copyWith(experience: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MatchReasonModelImplCopyWith<$Res>
    implements $MatchReasonModelCopyWith<$Res> {
  factory _$$MatchReasonModelImplCopyWith(_$MatchReasonModelImpl value,
          $Res Function(_$MatchReasonModelImpl) then) =
      __$$MatchReasonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int overallScore,
      DimensionScore skills,
      DimensionScore workStyle,
      DimensionScore experience,
      String coachingTip,
      String matchSummary});

  @override
  $DimensionScoreCopyWith<$Res> get skills;
  @override
  $DimensionScoreCopyWith<$Res> get workStyle;
  @override
  $DimensionScoreCopyWith<$Res> get experience;
}

/// @nodoc
class __$$MatchReasonModelImplCopyWithImpl<$Res>
    extends _$MatchReasonModelCopyWithImpl<$Res, _$MatchReasonModelImpl>
    implements _$$MatchReasonModelImplCopyWith<$Res> {
  __$$MatchReasonModelImplCopyWithImpl(_$MatchReasonModelImpl _value,
      $Res Function(_$MatchReasonModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overallScore = null,
    Object? skills = null,
    Object? workStyle = null,
    Object? experience = null,
    Object? coachingTip = null,
    Object? matchSummary = null,
  }) {
    return _then(_$MatchReasonModelImpl(
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as int,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as DimensionScore,
      workStyle: null == workStyle
          ? _value.workStyle
          : workStyle // ignore: cast_nullable_to_non_nullable
              as DimensionScore,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as DimensionScore,
      coachingTip: null == coachingTip
          ? _value.coachingTip
          : coachingTip // ignore: cast_nullable_to_non_nullable
              as String,
      matchSummary: null == matchSummary
          ? _value.matchSummary
          : matchSummary // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchReasonModelImpl implements _MatchReasonModel {
  const _$MatchReasonModelImpl(
      {required this.overallScore,
      required this.skills,
      required this.workStyle,
      required this.experience,
      required this.coachingTip,
      required this.matchSummary});

  factory _$MatchReasonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchReasonModelImplFromJson(json);

  @override
  final int overallScore;
  @override
  final DimensionScore skills;
  @override
  final DimensionScore workStyle;
  @override
  final DimensionScore experience;
  @override
  final String coachingTip;
  @override
  final String matchSummary;

  @override
  String toString() {
    return 'MatchReasonModel(overallScore: $overallScore, skills: $skills, workStyle: $workStyle, experience: $experience, coachingTip: $coachingTip, matchSummary: $matchSummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchReasonModelImpl &&
            (identical(other.overallScore, overallScore) ||
                other.overallScore == overallScore) &&
            (identical(other.skills, skills) || other.skills == skills) &&
            (identical(other.workStyle, workStyle) ||
                other.workStyle == workStyle) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            (identical(other.coachingTip, coachingTip) ||
                other.coachingTip == coachingTip) &&
            (identical(other.matchSummary, matchSummary) ||
                other.matchSummary == matchSummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, overallScore, skills, workStyle,
      experience, coachingTip, matchSummary);

  /// Create a copy of MatchReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchReasonModelImplCopyWith<_$MatchReasonModelImpl> get copyWith =>
      __$$MatchReasonModelImplCopyWithImpl<_$MatchReasonModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchReasonModelImplToJson(
      this,
    );
  }
}

abstract class _MatchReasonModel implements MatchReasonModel {
  const factory _MatchReasonModel(
      {required final int overallScore,
      required final DimensionScore skills,
      required final DimensionScore workStyle,
      required final DimensionScore experience,
      required final String coachingTip,
      required final String matchSummary}) = _$MatchReasonModelImpl;

  factory _MatchReasonModel.fromJson(Map<String, dynamic> json) =
      _$MatchReasonModelImpl.fromJson;

  @override
  int get overallScore;
  @override
  DimensionScore get skills;
  @override
  DimensionScore get workStyle;
  @override
  DimensionScore get experience;
  @override
  String get coachingTip;
  @override
  String get matchSummary;

  /// Create a copy of MatchReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchReasonModelImplCopyWith<_$MatchReasonModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
