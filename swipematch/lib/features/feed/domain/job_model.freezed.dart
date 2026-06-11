// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JobModel _$JobModelFromJson(Map<String, dynamic> json) {
  return _JobModel.fromJson(json);
}

/// @nodoc
mixin _$JobModel {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get requiredSkills => throw _privateConstructorUsedError;
  String get workStyle => throw _privateConstructorUsedError;
  int get experienceYears => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get expiresAt =>
      throw _privateConstructorUsedError; // Computed fields from Edge Function
  int get matchScore => throw _privateConstructorUsedError;
  List<String> get matchReasons => throw _privateConstructorUsedError;
  String? get matchSummary =>
      throw _privateConstructorUsedError; // Social proof
  int get applicantCount => throw _privateConstructorUsedError;
  bool get isHot => throw _privateConstructorUsedError; // Company info joined
  String? get companyName => throw _privateConstructorUsedError;
  String? get companyLogoUrl => throw _privateConstructorUsedError;
  String? get companyColor => throw _privateConstructorUsedError;
  int? get companyGhostScore => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this JobModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobModelCopyWith<JobModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobModelCopyWith<$Res> {
  factory $JobModelCopyWith(JobModel value, $Res Function(JobModel) then) =
      _$JobModelCopyWithImpl<$Res, JobModel>;
  @useResult
  $Res call(
      {String id,
      String companyId,
      String title,
      String description,
      List<String> requiredSkills,
      String workStyle,
      int experienceYears,
      bool isActive,
      DateTime? expiresAt,
      int matchScore,
      List<String> matchReasons,
      String? matchSummary,
      int applicantCount,
      bool isHot,
      String? companyName,
      String? companyLogoUrl,
      String? companyColor,
      int? companyGhostScore,
      DateTime createdAt});
}

/// @nodoc
class _$JobModelCopyWithImpl<$Res, $Val extends JobModel>
    implements $JobModelCopyWith<$Res> {
  _$JobModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? title = null,
    Object? description = null,
    Object? requiredSkills = null,
    Object? workStyle = null,
    Object? experienceYears = null,
    Object? isActive = null,
    Object? expiresAt = freezed,
    Object? matchScore = null,
    Object? matchReasons = null,
    Object? matchSummary = freezed,
    Object? applicantCount = null,
    Object? isHot = null,
    Object? companyName = freezed,
    Object? companyLogoUrl = freezed,
    Object? companyColor = freezed,
    Object? companyGhostScore = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      requiredSkills: null == requiredSkills
          ? _value.requiredSkills
          : requiredSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      workStyle: null == workStyle
          ? _value.workStyle
          : workStyle // ignore: cast_nullable_to_non_nullable
              as String,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      matchReasons: null == matchReasons
          ? _value.matchReasons
          : matchReasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      matchSummary: freezed == matchSummary
          ? _value.matchSummary
          : matchSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      applicantCount: null == applicantCount
          ? _value.applicantCount
          : applicantCount // ignore: cast_nullable_to_non_nullable
              as int,
      isHot: null == isHot
          ? _value.isHot
          : isHot // ignore: cast_nullable_to_non_nullable
              as bool,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyLogoUrl: freezed == companyLogoUrl
          ? _value.companyLogoUrl
          : companyLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      companyColor: freezed == companyColor
          ? _value.companyColor
          : companyColor // ignore: cast_nullable_to_non_nullable
              as String?,
      companyGhostScore: freezed == companyGhostScore
          ? _value.companyGhostScore
          : companyGhostScore // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JobModelImplCopyWith<$Res>
    implements $JobModelCopyWith<$Res> {
  factory _$$JobModelImplCopyWith(
          _$JobModelImpl value, $Res Function(_$JobModelImpl) then) =
      __$$JobModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String companyId,
      String title,
      String description,
      List<String> requiredSkills,
      String workStyle,
      int experienceYears,
      bool isActive,
      DateTime? expiresAt,
      int matchScore,
      List<String> matchReasons,
      String? matchSummary,
      int applicantCount,
      bool isHot,
      String? companyName,
      String? companyLogoUrl,
      String? companyColor,
      int? companyGhostScore,
      DateTime createdAt});
}

/// @nodoc
class __$$JobModelImplCopyWithImpl<$Res>
    extends _$JobModelCopyWithImpl<$Res, _$JobModelImpl>
    implements _$$JobModelImplCopyWith<$Res> {
  __$$JobModelImplCopyWithImpl(
      _$JobModelImpl _value, $Res Function(_$JobModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? title = null,
    Object? description = null,
    Object? requiredSkills = null,
    Object? workStyle = null,
    Object? experienceYears = null,
    Object? isActive = null,
    Object? expiresAt = freezed,
    Object? matchScore = null,
    Object? matchReasons = null,
    Object? matchSummary = freezed,
    Object? applicantCount = null,
    Object? isHot = null,
    Object? companyName = freezed,
    Object? companyLogoUrl = freezed,
    Object? companyColor = freezed,
    Object? companyGhostScore = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$JobModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      requiredSkills: null == requiredSkills
          ? _value._requiredSkills
          : requiredSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      workStyle: null == workStyle
          ? _value.workStyle
          : workStyle // ignore: cast_nullable_to_non_nullable
              as String,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      matchReasons: null == matchReasons
          ? _value._matchReasons
          : matchReasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      matchSummary: freezed == matchSummary
          ? _value.matchSummary
          : matchSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      applicantCount: null == applicantCount
          ? _value.applicantCount
          : applicantCount // ignore: cast_nullable_to_non_nullable
              as int,
      isHot: null == isHot
          ? _value.isHot
          : isHot // ignore: cast_nullable_to_non_nullable
              as bool,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyLogoUrl: freezed == companyLogoUrl
          ? _value.companyLogoUrl
          : companyLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      companyColor: freezed == companyColor
          ? _value.companyColor
          : companyColor // ignore: cast_nullable_to_non_nullable
              as String?,
      companyGhostScore: freezed == companyGhostScore
          ? _value.companyGhostScore
          : companyGhostScore // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JobModelImpl implements _JobModel {
  const _$JobModelImpl(
      {required this.id,
      required this.companyId,
      required this.title,
      required this.description,
      required final List<String> requiredSkills,
      required this.workStyle,
      required this.experienceYears,
      this.isActive = true,
      this.expiresAt,
      this.matchScore = 0,
      final List<String> matchReasons = const [],
      this.matchSummary,
      this.applicantCount = 0,
      this.isHot = false,
      this.companyName,
      this.companyLogoUrl,
      this.companyColor,
      this.companyGhostScore,
      required this.createdAt})
      : _requiredSkills = requiredSkills,
        _matchReasons = matchReasons;

  factory _$JobModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobModelImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final String title;
  @override
  final String description;
  final List<String> _requiredSkills;
  @override
  List<String> get requiredSkills {
    if (_requiredSkills is EqualUnmodifiableListView) return _requiredSkills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredSkills);
  }

  @override
  final String workStyle;
  @override
  final int experienceYears;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? expiresAt;
// Computed fields from Edge Function
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
  final String? matchSummary;
// Social proof
  @override
  @JsonKey()
  final int applicantCount;
  @override
  @JsonKey()
  final bool isHot;
// Company info joined
  @override
  final String? companyName;
  @override
  final String? companyLogoUrl;
  @override
  final String? companyColor;
  @override
  final int? companyGhostScore;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'JobModel(id: $id, companyId: $companyId, title: $title, description: $description, requiredSkills: $requiredSkills, workStyle: $workStyle, experienceYears: $experienceYears, isActive: $isActive, expiresAt: $expiresAt, matchScore: $matchScore, matchReasons: $matchReasons, matchSummary: $matchSummary, applicantCount: $applicantCount, isHot: $isHot, companyName: $companyName, companyLogoUrl: $companyLogoUrl, companyColor: $companyColor, companyGhostScore: $companyGhostScore, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._requiredSkills, _requiredSkills) &&
            (identical(other.workStyle, workStyle) ||
                other.workStyle == workStyle) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.matchScore, matchScore) ||
                other.matchScore == matchScore) &&
            const DeepCollectionEquality()
                .equals(other._matchReasons, _matchReasons) &&
            (identical(other.matchSummary, matchSummary) ||
                other.matchSummary == matchSummary) &&
            (identical(other.applicantCount, applicantCount) ||
                other.applicantCount == applicantCount) &&
            (identical(other.isHot, isHot) || other.isHot == isHot) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.companyLogoUrl, companyLogoUrl) ||
                other.companyLogoUrl == companyLogoUrl) &&
            (identical(other.companyColor, companyColor) ||
                other.companyColor == companyColor) &&
            (identical(other.companyGhostScore, companyGhostScore) ||
                other.companyGhostScore == companyGhostScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        companyId,
        title,
        description,
        const DeepCollectionEquality().hash(_requiredSkills),
        workStyle,
        experienceYears,
        isActive,
        expiresAt,
        matchScore,
        const DeepCollectionEquality().hash(_matchReasons),
        matchSummary,
        applicantCount,
        isHot,
        companyName,
        companyLogoUrl,
        companyColor,
        companyGhostScore,
        createdAt
      ]);

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      __$$JobModelImplCopyWithImpl<_$JobModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobModelImplToJson(
      this,
    );
  }
}

abstract class _JobModel implements JobModel {
  const factory _JobModel(
      {required final String id,
      required final String companyId,
      required final String title,
      required final String description,
      required final List<String> requiredSkills,
      required final String workStyle,
      required final int experienceYears,
      final bool isActive,
      final DateTime? expiresAt,
      final int matchScore,
      final List<String> matchReasons,
      final String? matchSummary,
      final int applicantCount,
      final bool isHot,
      final String? companyName,
      final String? companyLogoUrl,
      final String? companyColor,
      final int? companyGhostScore,
      required final DateTime createdAt}) = _$JobModelImpl;

  factory _JobModel.fromJson(Map<String, dynamic> json) =
      _$JobModelImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  String get title;
  @override
  String get description;
  @override
  List<String> get requiredSkills;
  @override
  String get workStyle;
  @override
  int get experienceYears;
  @override
  bool get isActive;
  @override
  DateTime? get expiresAt; // Computed fields from Edge Function
  @override
  int get matchScore;
  @override
  List<String> get matchReasons;
  @override
  String? get matchSummary; // Social proof
  @override
  int get applicantCount;
  @override
  bool get isHot; // Company info joined
  @override
  String? get companyName;
  @override
  String? get companyLogoUrl;
  @override
  String? get companyColor;
  @override
  int? get companyGhostScore;
  @override
  DateTime get createdAt;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
