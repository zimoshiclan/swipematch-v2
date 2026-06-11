// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return _ProfileModel.fromJson(json);
}

/// @nodoc
mixin _$ProfileModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get headline => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  String? get persona => throw _privateConstructorUsedError;
  List<String> get connectionIntents => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get workStyle => throw _privateConstructorUsedError;
  List<String> get cultureTags => throw _privateConstructorUsedError;
  int? get experienceYears => throw _privateConstructorUsedError;
  int get streakCount => throw _privateConstructorUsedError;
  DateTime? get lastActiveDate => throw _privateConstructorUsedError;
  bool get passiveMode => throw _privateConstructorUsedError;
  int get profileCompletion => throw _privateConstructorUsedError;
  String? get jobSearchTimeline => throw _privateConstructorUsedError;
  String? get videoPitchUrl => throw _privateConstructorUsedError;
  String? get videoPitchTranscript => throw _privateConstructorUsedError;
  int? get aiReadinessScore => throw _privateConstructorUsedError;
  String? get workingToward => throw _privateConstructorUsedError;
  String? get currentlyLearning => throw _privateConstructorUsedError;
  List<String> get workValues => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Transient UI-only flag: set by the Room when this card is a serendipity
// "wildcard" pick. Never read from / written to the database.
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSerendipity => throw _privateConstructorUsedError;

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileModelCopyWith<ProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileModelCopyWith<$Res> {
  factory $ProfileModelCopyWith(
          ProfileModel value, $Res Function(ProfileModel) then) =
      _$ProfileModelCopyWithImpl<$Res, ProfileModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String role,
      String name,
      String? headline,
      String? avatarUrl,
      String? bio,
      List<String> skills,
      String? persona,
      List<String> connectionIntents,
      String? city,
      String? country,
      String? workStyle,
      List<String> cultureTags,
      int? experienceYears,
      int streakCount,
      DateTime? lastActiveDate,
      bool passiveMode,
      int profileCompletion,
      String? jobSearchTimeline,
      String? videoPitchUrl,
      String? videoPitchTranscript,
      int? aiReadinessScore,
      String? workingToward,
      String? currentlyLearning,
      List<String> workValues,
      DateTime createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      bool isSerendipity});
}

/// @nodoc
class _$ProfileModelCopyWithImpl<$Res, $Val extends ProfileModel>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? role = null,
    Object? name = null,
    Object? headline = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
    Object? skills = null,
    Object? persona = freezed,
    Object? connectionIntents = null,
    Object? city = freezed,
    Object? country = freezed,
    Object? workStyle = freezed,
    Object? cultureTags = null,
    Object? experienceYears = freezed,
    Object? streakCount = null,
    Object? lastActiveDate = freezed,
    Object? passiveMode = null,
    Object? profileCompletion = null,
    Object? jobSearchTimeline = freezed,
    Object? videoPitchUrl = freezed,
    Object? videoPitchTranscript = freezed,
    Object? aiReadinessScore = freezed,
    Object? workingToward = freezed,
    Object? currentlyLearning = freezed,
    Object? workValues = null,
    Object? createdAt = null,
    Object? isSerendipity = null,
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
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      headline: freezed == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      persona: freezed == persona
          ? _value.persona
          : persona // ignore: cast_nullable_to_non_nullable
              as String?,
      connectionIntents: null == connectionIntents
          ? _value.connectionIntents
          : connectionIntents // ignore: cast_nullable_to_non_nullable
              as List<String>,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      workStyle: freezed == workStyle
          ? _value.workStyle
          : workStyle // ignore: cast_nullable_to_non_nullable
              as String?,
      cultureTags: null == cultureTags
          ? _value.cultureTags
          : cultureTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      experienceYears: freezed == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int?,
      streakCount: null == streakCount
          ? _value.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastActiveDate: freezed == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      passiveMode: null == passiveMode
          ? _value.passiveMode
          : passiveMode // ignore: cast_nullable_to_non_nullable
              as bool,
      profileCompletion: null == profileCompletion
          ? _value.profileCompletion
          : profileCompletion // ignore: cast_nullable_to_non_nullable
              as int,
      jobSearchTimeline: freezed == jobSearchTimeline
          ? _value.jobSearchTimeline
          : jobSearchTimeline // ignore: cast_nullable_to_non_nullable
              as String?,
      videoPitchUrl: freezed == videoPitchUrl
          ? _value.videoPitchUrl
          : videoPitchUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoPitchTranscript: freezed == videoPitchTranscript
          ? _value.videoPitchTranscript
          : videoPitchTranscript // ignore: cast_nullable_to_non_nullable
              as String?,
      aiReadinessScore: freezed == aiReadinessScore
          ? _value.aiReadinessScore
          : aiReadinessScore // ignore: cast_nullable_to_non_nullable
              as int?,
      workingToward: freezed == workingToward
          ? _value.workingToward
          : workingToward // ignore: cast_nullable_to_non_nullable
              as String?,
      currentlyLearning: freezed == currentlyLearning
          ? _value.currentlyLearning
          : currentlyLearning // ignore: cast_nullable_to_non_nullable
              as String?,
      workValues: null == workValues
          ? _value.workValues
          : workValues // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSerendipity: null == isSerendipity
          ? _value.isSerendipity
          : isSerendipity // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileModelImplCopyWith<$Res>
    implements $ProfileModelCopyWith<$Res> {
  factory _$$ProfileModelImplCopyWith(
          _$ProfileModelImpl value, $Res Function(_$ProfileModelImpl) then) =
      __$$ProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String role,
      String name,
      String? headline,
      String? avatarUrl,
      String? bio,
      List<String> skills,
      String? persona,
      List<String> connectionIntents,
      String? city,
      String? country,
      String? workStyle,
      List<String> cultureTags,
      int? experienceYears,
      int streakCount,
      DateTime? lastActiveDate,
      bool passiveMode,
      int profileCompletion,
      String? jobSearchTimeline,
      String? videoPitchUrl,
      String? videoPitchTranscript,
      int? aiReadinessScore,
      String? workingToward,
      String? currentlyLearning,
      List<String> workValues,
      DateTime createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      bool isSerendipity});
}

/// @nodoc
class __$$ProfileModelImplCopyWithImpl<$Res>
    extends _$ProfileModelCopyWithImpl<$Res, _$ProfileModelImpl>
    implements _$$ProfileModelImplCopyWith<$Res> {
  __$$ProfileModelImplCopyWithImpl(
      _$ProfileModelImpl _value, $Res Function(_$ProfileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? role = null,
    Object? name = null,
    Object? headline = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
    Object? skills = null,
    Object? persona = freezed,
    Object? connectionIntents = null,
    Object? city = freezed,
    Object? country = freezed,
    Object? workStyle = freezed,
    Object? cultureTags = null,
    Object? experienceYears = freezed,
    Object? streakCount = null,
    Object? lastActiveDate = freezed,
    Object? passiveMode = null,
    Object? profileCompletion = null,
    Object? jobSearchTimeline = freezed,
    Object? videoPitchUrl = freezed,
    Object? videoPitchTranscript = freezed,
    Object? aiReadinessScore = freezed,
    Object? workingToward = freezed,
    Object? currentlyLearning = freezed,
    Object? workValues = null,
    Object? createdAt = null,
    Object? isSerendipity = null,
  }) {
    return _then(_$ProfileModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      headline: freezed == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      skills: null == skills
          ? _value._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      persona: freezed == persona
          ? _value.persona
          : persona // ignore: cast_nullable_to_non_nullable
              as String?,
      connectionIntents: null == connectionIntents
          ? _value._connectionIntents
          : connectionIntents // ignore: cast_nullable_to_non_nullable
              as List<String>,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      workStyle: freezed == workStyle
          ? _value.workStyle
          : workStyle // ignore: cast_nullable_to_non_nullable
              as String?,
      cultureTags: null == cultureTags
          ? _value._cultureTags
          : cultureTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      experienceYears: freezed == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int?,
      streakCount: null == streakCount
          ? _value.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastActiveDate: freezed == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      passiveMode: null == passiveMode
          ? _value.passiveMode
          : passiveMode // ignore: cast_nullable_to_non_nullable
              as bool,
      profileCompletion: null == profileCompletion
          ? _value.profileCompletion
          : profileCompletion // ignore: cast_nullable_to_non_nullable
              as int,
      jobSearchTimeline: freezed == jobSearchTimeline
          ? _value.jobSearchTimeline
          : jobSearchTimeline // ignore: cast_nullable_to_non_nullable
              as String?,
      videoPitchUrl: freezed == videoPitchUrl
          ? _value.videoPitchUrl
          : videoPitchUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoPitchTranscript: freezed == videoPitchTranscript
          ? _value.videoPitchTranscript
          : videoPitchTranscript // ignore: cast_nullable_to_non_nullable
              as String?,
      aiReadinessScore: freezed == aiReadinessScore
          ? _value.aiReadinessScore
          : aiReadinessScore // ignore: cast_nullable_to_non_nullable
              as int?,
      workingToward: freezed == workingToward
          ? _value.workingToward
          : workingToward // ignore: cast_nullable_to_non_nullable
              as String?,
      currentlyLearning: freezed == currentlyLearning
          ? _value.currentlyLearning
          : currentlyLearning // ignore: cast_nullable_to_non_nullable
              as String?,
      workValues: null == workValues
          ? _value._workValues
          : workValues // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSerendipity: null == isSerendipity
          ? _value.isSerendipity
          : isSerendipity // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileModelImpl implements _ProfileModel {
  const _$ProfileModelImpl(
      {required this.id,
      required this.userId,
      required this.role,
      required this.name,
      this.headline,
      this.avatarUrl,
      this.bio,
      final List<String> skills = const [],
      this.persona,
      final List<String> connectionIntents = const [],
      this.city,
      this.country,
      this.workStyle,
      final List<String> cultureTags = const [],
      this.experienceYears,
      this.streakCount = 0,
      this.lastActiveDate,
      this.passiveMode = false,
      this.profileCompletion = 0,
      this.jobSearchTimeline,
      this.videoPitchUrl,
      this.videoPitchTranscript,
      this.aiReadinessScore,
      this.workingToward,
      this.currentlyLearning,
      final List<String> workValues = const [],
      required this.createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isSerendipity = false})
      : _skills = skills,
        _connectionIntents = connectionIntents,
        _cultureTags = cultureTags,
        _workValues = workValues;

  factory _$ProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String role;
  @override
  final String name;
  @override
  final String? headline;
  @override
  final String? avatarUrl;
  @override
  final String? bio;
  final List<String> _skills;
  @override
  @JsonKey()
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  @override
  final String? persona;
  final List<String> _connectionIntents;
  @override
  @JsonKey()
  List<String> get connectionIntents {
    if (_connectionIntents is EqualUnmodifiableListView)
      return _connectionIntents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_connectionIntents);
  }

  @override
  final String? city;
  @override
  final String? country;
  @override
  final String? workStyle;
  final List<String> _cultureTags;
  @override
  @JsonKey()
  List<String> get cultureTags {
    if (_cultureTags is EqualUnmodifiableListView) return _cultureTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cultureTags);
  }

  @override
  final int? experienceYears;
  @override
  @JsonKey()
  final int streakCount;
  @override
  final DateTime? lastActiveDate;
  @override
  @JsonKey()
  final bool passiveMode;
  @override
  @JsonKey()
  final int profileCompletion;
  @override
  final String? jobSearchTimeline;
  @override
  final String? videoPitchUrl;
  @override
  final String? videoPitchTranscript;
  @override
  final int? aiReadinessScore;
  @override
  final String? workingToward;
  @override
  final String? currentlyLearning;
  final List<String> _workValues;
  @override
  @JsonKey()
  List<String> get workValues {
    if (_workValues is EqualUnmodifiableListView) return _workValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workValues);
  }

  @override
  final DateTime createdAt;
// Transient UI-only flag: set by the Room when this card is a serendipity
// "wildcard" pick. Never read from / written to the database.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isSerendipity;

  @override
  String toString() {
    return 'ProfileModel(id: $id, userId: $userId, role: $role, name: $name, headline: $headline, avatarUrl: $avatarUrl, bio: $bio, skills: $skills, persona: $persona, connectionIntents: $connectionIntents, city: $city, country: $country, workStyle: $workStyle, cultureTags: $cultureTags, experienceYears: $experienceYears, streakCount: $streakCount, lastActiveDate: $lastActiveDate, passiveMode: $passiveMode, profileCompletion: $profileCompletion, jobSearchTimeline: $jobSearchTimeline, videoPitchUrl: $videoPitchUrl, videoPitchTranscript: $videoPitchTranscript, aiReadinessScore: $aiReadinessScore, workingToward: $workingToward, currentlyLearning: $currentlyLearning, workValues: $workValues, createdAt: $createdAt, isSerendipity: $isSerendipity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            (identical(other.persona, persona) || other.persona == persona) &&
            const DeepCollectionEquality()
                .equals(other._connectionIntents, _connectionIntents) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.workStyle, workStyle) ||
                other.workStyle == workStyle) &&
            const DeepCollectionEquality()
                .equals(other._cultureTags, _cultureTags) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate) &&
            (identical(other.passiveMode, passiveMode) ||
                other.passiveMode == passiveMode) &&
            (identical(other.profileCompletion, profileCompletion) ||
                other.profileCompletion == profileCompletion) &&
            (identical(other.jobSearchTimeline, jobSearchTimeline) ||
                other.jobSearchTimeline == jobSearchTimeline) &&
            (identical(other.videoPitchUrl, videoPitchUrl) ||
                other.videoPitchUrl == videoPitchUrl) &&
            (identical(other.videoPitchTranscript, videoPitchTranscript) ||
                other.videoPitchTranscript == videoPitchTranscript) &&
            (identical(other.aiReadinessScore, aiReadinessScore) ||
                other.aiReadinessScore == aiReadinessScore) &&
            (identical(other.workingToward, workingToward) ||
                other.workingToward == workingToward) &&
            (identical(other.currentlyLearning, currentlyLearning) ||
                other.currentlyLearning == currentlyLearning) &&
            const DeepCollectionEquality()
                .equals(other._workValues, _workValues) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isSerendipity, isSerendipity) ||
                other.isSerendipity == isSerendipity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        role,
        name,
        headline,
        avatarUrl,
        bio,
        const DeepCollectionEquality().hash(_skills),
        persona,
        const DeepCollectionEquality().hash(_connectionIntents),
        city,
        country,
        workStyle,
        const DeepCollectionEquality().hash(_cultureTags),
        experienceYears,
        streakCount,
        lastActiveDate,
        passiveMode,
        profileCompletion,
        jobSearchTimeline,
        videoPitchUrl,
        videoPitchTranscript,
        aiReadinessScore,
        workingToward,
        currentlyLearning,
        const DeepCollectionEquality().hash(_workValues),
        createdAt,
        isSerendipity
      ]);

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      __$$ProfileModelImplCopyWithImpl<_$ProfileModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileModelImplToJson(
      this,
    );
  }
}

abstract class _ProfileModel implements ProfileModel {
  const factory _ProfileModel(
      {required final String id,
      required final String userId,
      required final String role,
      required final String name,
      final String? headline,
      final String? avatarUrl,
      final String? bio,
      final List<String> skills,
      final String? persona,
      final List<String> connectionIntents,
      final String? city,
      final String? country,
      final String? workStyle,
      final List<String> cultureTags,
      final int? experienceYears,
      final int streakCount,
      final DateTime? lastActiveDate,
      final bool passiveMode,
      final int profileCompletion,
      final String? jobSearchTimeline,
      final String? videoPitchUrl,
      final String? videoPitchTranscript,
      final int? aiReadinessScore,
      final String? workingToward,
      final String? currentlyLearning,
      final List<String> workValues,
      required final DateTime createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final bool isSerendipity}) = _$ProfileModelImpl;

  factory _ProfileModel.fromJson(Map<String, dynamic> json) =
      _$ProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get role;
  @override
  String get name;
  @override
  String? get headline;
  @override
  String? get avatarUrl;
  @override
  String? get bio;
  @override
  List<String> get skills;
  @override
  String? get persona;
  @override
  List<String> get connectionIntents;
  @override
  String? get city;
  @override
  String? get country;
  @override
  String? get workStyle;
  @override
  List<String> get cultureTags;
  @override
  int? get experienceYears;
  @override
  int get streakCount;
  @override
  DateTime? get lastActiveDate;
  @override
  bool get passiveMode;
  @override
  int get profileCompletion;
  @override
  String? get jobSearchTimeline;
  @override
  String? get videoPitchUrl;
  @override
  String? get videoPitchTranscript;
  @override
  int? get aiReadinessScore;
  @override
  String? get workingToward;
  @override
  String? get currentlyLearning;
  @override
  List<String> get workValues;
  @override
  DateTime
      get createdAt; // Transient UI-only flag: set by the Room when this card is a serendipity
// "wildcard" pick. Never read from / written to the database.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSerendipity;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
