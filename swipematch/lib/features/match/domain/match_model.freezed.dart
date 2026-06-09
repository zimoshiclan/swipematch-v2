// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) {
  return _MatchModel.fromJson(json);
}

/// @nodoc
mixin _$MatchModel {
  String get id => throw _privateConstructorUsedError;
  String get candidateId => throw _privateConstructorUsedError;
  String get jobId => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  int get matchScore => throw _privateConstructorUsedError;
  MatchReasonModel get matchReason => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get ghostedAt => throw _privateConstructorUsedError;
  DateTime? get firstResponseAt =>
      throw _privateConstructorUsedError; // Joined fields
  String? get jobTitle => throw _privateConstructorUsedError;
  String? get companyName => throw _privateConstructorUsedError;
  String? get companyLogoUrl => throw _privateConstructorUsedError;
  int? get companyGhostScore => throw _privateConstructorUsedError;
  String? get candidateName => throw _privateConstructorUsedError;
  String? get candidateAvatarUrl => throw _privateConstructorUsedError;
  String? get candidateVideoPitchUrl => throw _privateConstructorUsedError;

  /// Serializes this MatchModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchModelCopyWith<MatchModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchModelCopyWith<$Res> {
  factory $MatchModelCopyWith(
          MatchModel value, $Res Function(MatchModel) then) =
      _$MatchModelCopyWithImpl<$Res, MatchModel>;
  @useResult
  $Res call(
      {String id,
      String candidateId,
      String jobId,
      String companyId,
      int matchScore,
      MatchReasonModel matchReason,
      String status,
      DateTime createdAt,
      DateTime? ghostedAt,
      DateTime? firstResponseAt,
      String? jobTitle,
      String? companyName,
      String? companyLogoUrl,
      int? companyGhostScore,
      String? candidateName,
      String? candidateAvatarUrl,
      String? candidateVideoPitchUrl});

  $MatchReasonModelCopyWith<$Res> get matchReason;
}

/// @nodoc
class _$MatchModelCopyWithImpl<$Res, $Val extends MatchModel>
    implements $MatchModelCopyWith<$Res> {
  _$MatchModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? candidateId = null,
    Object? jobId = null,
    Object? companyId = null,
    Object? matchScore = null,
    Object? matchReason = null,
    Object? status = null,
    Object? createdAt = null,
    Object? ghostedAt = freezed,
    Object? firstResponseAt = freezed,
    Object? jobTitle = freezed,
    Object? companyName = freezed,
    Object? companyLogoUrl = freezed,
    Object? companyGhostScore = freezed,
    Object? candidateName = freezed,
    Object? candidateAvatarUrl = freezed,
    Object? candidateVideoPitchUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      candidateId: null == candidateId
          ? _value.candidateId
          : candidateId // ignore: cast_nullable_to_non_nullable
              as String,
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      matchReason: null == matchReason
          ? _value.matchReason
          : matchReason // ignore: cast_nullable_to_non_nullable
              as MatchReasonModel,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ghostedAt: freezed == ghostedAt
          ? _value.ghostedAt
          : ghostedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      firstResponseAt: freezed == firstResponseAt
          ? _value.firstResponseAt
          : firstResponseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyLogoUrl: freezed == companyLogoUrl
          ? _value.companyLogoUrl
          : companyLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      companyGhostScore: freezed == companyGhostScore
          ? _value.companyGhostScore
          : companyGhostScore // ignore: cast_nullable_to_non_nullable
              as int?,
      candidateName: freezed == candidateName
          ? _value.candidateName
          : candidateName // ignore: cast_nullable_to_non_nullable
              as String?,
      candidateAvatarUrl: freezed == candidateAvatarUrl
          ? _value.candidateAvatarUrl
          : candidateAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      candidateVideoPitchUrl: freezed == candidateVideoPitchUrl
          ? _value.candidateVideoPitchUrl
          : candidateVideoPitchUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchReasonModelCopyWith<$Res> get matchReason {
    return $MatchReasonModelCopyWith<$Res>(_value.matchReason, (value) {
      return _then(_value.copyWith(matchReason: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MatchModelImplCopyWith<$Res>
    implements $MatchModelCopyWith<$Res> {
  factory _$$MatchModelImplCopyWith(
          _$MatchModelImpl value, $Res Function(_$MatchModelImpl) then) =
      __$$MatchModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String candidateId,
      String jobId,
      String companyId,
      int matchScore,
      MatchReasonModel matchReason,
      String status,
      DateTime createdAt,
      DateTime? ghostedAt,
      DateTime? firstResponseAt,
      String? jobTitle,
      String? companyName,
      String? companyLogoUrl,
      int? companyGhostScore,
      String? candidateName,
      String? candidateAvatarUrl,
      String? candidateVideoPitchUrl});

  @override
  $MatchReasonModelCopyWith<$Res> get matchReason;
}

/// @nodoc
class __$$MatchModelImplCopyWithImpl<$Res>
    extends _$MatchModelCopyWithImpl<$Res, _$MatchModelImpl>
    implements _$$MatchModelImplCopyWith<$Res> {
  __$$MatchModelImplCopyWithImpl(
      _$MatchModelImpl _value, $Res Function(_$MatchModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? candidateId = null,
    Object? jobId = null,
    Object? companyId = null,
    Object? matchScore = null,
    Object? matchReason = null,
    Object? status = null,
    Object? createdAt = null,
    Object? ghostedAt = freezed,
    Object? firstResponseAt = freezed,
    Object? jobTitle = freezed,
    Object? companyName = freezed,
    Object? companyLogoUrl = freezed,
    Object? companyGhostScore = freezed,
    Object? candidateName = freezed,
    Object? candidateAvatarUrl = freezed,
    Object? candidateVideoPitchUrl = freezed,
  }) {
    return _then(_$MatchModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      candidateId: null == candidateId
          ? _value.candidateId
          : candidateId // ignore: cast_nullable_to_non_nullable
              as String,
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      matchReason: null == matchReason
          ? _value.matchReason
          : matchReason // ignore: cast_nullable_to_non_nullable
              as MatchReasonModel,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ghostedAt: freezed == ghostedAt
          ? _value.ghostedAt
          : ghostedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      firstResponseAt: freezed == firstResponseAt
          ? _value.firstResponseAt
          : firstResponseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyLogoUrl: freezed == companyLogoUrl
          ? _value.companyLogoUrl
          : companyLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      companyGhostScore: freezed == companyGhostScore
          ? _value.companyGhostScore
          : companyGhostScore // ignore: cast_nullable_to_non_nullable
              as int?,
      candidateName: freezed == candidateName
          ? _value.candidateName
          : candidateName // ignore: cast_nullable_to_non_nullable
              as String?,
      candidateAvatarUrl: freezed == candidateAvatarUrl
          ? _value.candidateAvatarUrl
          : candidateAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      candidateVideoPitchUrl: freezed == candidateVideoPitchUrl
          ? _value.candidateVideoPitchUrl
          : candidateVideoPitchUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchModelImpl implements _MatchModel {
  const _$MatchModelImpl(
      {required this.id,
      required this.candidateId,
      required this.jobId,
      required this.companyId,
      required this.matchScore,
      required this.matchReason,
      required this.status,
      required this.createdAt,
      this.ghostedAt,
      this.firstResponseAt,
      this.jobTitle,
      this.companyName,
      this.companyLogoUrl,
      this.companyGhostScore,
      this.candidateName,
      this.candidateAvatarUrl,
      this.candidateVideoPitchUrl});

  factory _$MatchModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchModelImplFromJson(json);

  @override
  final String id;
  @override
  final String candidateId;
  @override
  final String jobId;
  @override
  final String companyId;
  @override
  final int matchScore;
  @override
  final MatchReasonModel matchReason;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? ghostedAt;
  @override
  final DateTime? firstResponseAt;
// Joined fields
  @override
  final String? jobTitle;
  @override
  final String? companyName;
  @override
  final String? companyLogoUrl;
  @override
  final int? companyGhostScore;
  @override
  final String? candidateName;
  @override
  final String? candidateAvatarUrl;
  @override
  final String? candidateVideoPitchUrl;

  @override
  String toString() {
    return 'MatchModel(id: $id, candidateId: $candidateId, jobId: $jobId, companyId: $companyId, matchScore: $matchScore, matchReason: $matchReason, status: $status, createdAt: $createdAt, ghostedAt: $ghostedAt, firstResponseAt: $firstResponseAt, jobTitle: $jobTitle, companyName: $companyName, companyLogoUrl: $companyLogoUrl, companyGhostScore: $companyGhostScore, candidateName: $candidateName, candidateAvatarUrl: $candidateAvatarUrl, candidateVideoPitchUrl: $candidateVideoPitchUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.candidateId, candidateId) ||
                other.candidateId == candidateId) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.matchScore, matchScore) ||
                other.matchScore == matchScore) &&
            (identical(other.matchReason, matchReason) ||
                other.matchReason == matchReason) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.ghostedAt, ghostedAt) ||
                other.ghostedAt == ghostedAt) &&
            (identical(other.firstResponseAt, firstResponseAt) ||
                other.firstResponseAt == firstResponseAt) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.companyLogoUrl, companyLogoUrl) ||
                other.companyLogoUrl == companyLogoUrl) &&
            (identical(other.companyGhostScore, companyGhostScore) ||
                other.companyGhostScore == companyGhostScore) &&
            (identical(other.candidateName, candidateName) ||
                other.candidateName == candidateName) &&
            (identical(other.candidateAvatarUrl, candidateAvatarUrl) ||
                other.candidateAvatarUrl == candidateAvatarUrl) &&
            (identical(other.candidateVideoPitchUrl, candidateVideoPitchUrl) ||
                other.candidateVideoPitchUrl == candidateVideoPitchUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      candidateId,
      jobId,
      companyId,
      matchScore,
      matchReason,
      status,
      createdAt,
      ghostedAt,
      firstResponseAt,
      jobTitle,
      companyName,
      companyLogoUrl,
      companyGhostScore,
      candidateName,
      candidateAvatarUrl,
      candidateVideoPitchUrl);

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchModelImplCopyWith<_$MatchModelImpl> get copyWith =>
      __$$MatchModelImplCopyWithImpl<_$MatchModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchModelImplToJson(
      this,
    );
  }
}

abstract class _MatchModel implements MatchModel {
  const factory _MatchModel(
      {required final String id,
      required final String candidateId,
      required final String jobId,
      required final String companyId,
      required final int matchScore,
      required final MatchReasonModel matchReason,
      required final String status,
      required final DateTime createdAt,
      final DateTime? ghostedAt,
      final DateTime? firstResponseAt,
      final String? jobTitle,
      final String? companyName,
      final String? companyLogoUrl,
      final int? companyGhostScore,
      final String? candidateName,
      final String? candidateAvatarUrl,
      final String? candidateVideoPitchUrl}) = _$MatchModelImpl;

  factory _MatchModel.fromJson(Map<String, dynamic> json) =
      _$MatchModelImpl.fromJson;

  @override
  String get id;
  @override
  String get candidateId;
  @override
  String get jobId;
  @override
  String get companyId;
  @override
  int get matchScore;
  @override
  MatchReasonModel get matchReason;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get ghostedAt;
  @override
  DateTime? get firstResponseAt; // Joined fields
  @override
  String? get jobTitle;
  @override
  String? get companyName;
  @override
  String? get companyLogoUrl;
  @override
  int? get companyGhostScore;
  @override
  String? get candidateName;
  @override
  String? get candidateAvatarUrl;
  @override
  String? get candidateVideoPitchUrl;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchModelImplCopyWith<_$MatchModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
