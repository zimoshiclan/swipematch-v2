// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) {
  return _CompanyModel.fromJson(json);
}

/// @nodoc
mixin _$CompanyModel {
  String get id => throw _privateConstructorUsedError;
  String get employerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get size => throw _privateConstructorUsedError;
  List<String> get cultureTags => throw _privateConstructorUsedError;
  List<String> get techStack => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  int get ghostScore => throw _privateConstructorUsedError;
  Map<String, dynamic>? get truthScore => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CompanyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyModelCopyWith<CompanyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyModelCopyWith<$Res> {
  factory $CompanyModelCopyWith(
          CompanyModel value, $Res Function(CompanyModel) then) =
      _$CompanyModelCopyWithImpl<$Res, CompanyModel>;
  @useResult
  $Res call(
      {String id,
      String employerId,
      String name,
      String? logoUrl,
      String? size,
      List<String> cultureTags,
      List<String> techStack,
      String? description,
      String? website,
      int ghostScore,
      Map<String, dynamic>? truthScore,
      DateTime createdAt});
}

/// @nodoc
class _$CompanyModelCopyWithImpl<$Res, $Val extends CompanyModel>
    implements $CompanyModelCopyWith<$Res> {
  _$CompanyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employerId = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? size = freezed,
    Object? cultureTags = null,
    Object? techStack = null,
    Object? description = freezed,
    Object? website = freezed,
    Object? ghostScore = null,
    Object? truthScore = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employerId: null == employerId
          ? _value.employerId
          : employerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      cultureTags: null == cultureTags
          ? _value.cultureTags
          : cultureTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      techStack: null == techStack
          ? _value.techStack
          : techStack // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      ghostScore: null == ghostScore
          ? _value.ghostScore
          : ghostScore // ignore: cast_nullable_to_non_nullable
              as int,
      truthScore: freezed == truthScore
          ? _value.truthScore
          : truthScore // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanyModelImplCopyWith<$Res>
    implements $CompanyModelCopyWith<$Res> {
  factory _$$CompanyModelImplCopyWith(
          _$CompanyModelImpl value, $Res Function(_$CompanyModelImpl) then) =
      __$$CompanyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String employerId,
      String name,
      String? logoUrl,
      String? size,
      List<String> cultureTags,
      List<String> techStack,
      String? description,
      String? website,
      int ghostScore,
      Map<String, dynamic>? truthScore,
      DateTime createdAt});
}

/// @nodoc
class __$$CompanyModelImplCopyWithImpl<$Res>
    extends _$CompanyModelCopyWithImpl<$Res, _$CompanyModelImpl>
    implements _$$CompanyModelImplCopyWith<$Res> {
  __$$CompanyModelImplCopyWithImpl(
      _$CompanyModelImpl _value, $Res Function(_$CompanyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employerId = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? size = freezed,
    Object? cultureTags = null,
    Object? techStack = null,
    Object? description = freezed,
    Object? website = freezed,
    Object? ghostScore = null,
    Object? truthScore = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$CompanyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employerId: null == employerId
          ? _value.employerId
          : employerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      cultureTags: null == cultureTags
          ? _value._cultureTags
          : cultureTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      techStack: null == techStack
          ? _value._techStack
          : techStack // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      ghostScore: null == ghostScore
          ? _value.ghostScore
          : ghostScore // ignore: cast_nullable_to_non_nullable
              as int,
      truthScore: freezed == truthScore
          ? _value._truthScore
          : truthScore // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyModelImpl implements _CompanyModel {
  const _$CompanyModelImpl(
      {required this.id,
      required this.employerId,
      required this.name,
      this.logoUrl,
      this.size,
      final List<String> cultureTags = const [],
      final List<String> techStack = const [],
      this.description,
      this.website,
      this.ghostScore = 100,
      final Map<String, dynamic>? truthScore,
      required this.createdAt})
      : _cultureTags = cultureTags,
        _techStack = techStack,
        _truthScore = truthScore;

  factory _$CompanyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyModelImplFromJson(json);

  @override
  final String id;
  @override
  final String employerId;
  @override
  final String name;
  @override
  final String? logoUrl;
  @override
  final String? size;
  final List<String> _cultureTags;
  @override
  @JsonKey()
  List<String> get cultureTags {
    if (_cultureTags is EqualUnmodifiableListView) return _cultureTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cultureTags);
  }

  final List<String> _techStack;
  @override
  @JsonKey()
  List<String> get techStack {
    if (_techStack is EqualUnmodifiableListView) return _techStack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_techStack);
  }

  @override
  final String? description;
  @override
  final String? website;
  @override
  @JsonKey()
  final int ghostScore;
  final Map<String, dynamic>? _truthScore;
  @override
  Map<String, dynamic>? get truthScore {
    final value = _truthScore;
    if (value == null) return null;
    if (_truthScore is EqualUnmodifiableMapView) return _truthScore;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CompanyModel(id: $id, employerId: $employerId, name: $name, logoUrl: $logoUrl, size: $size, cultureTags: $cultureTags, techStack: $techStack, description: $description, website: $website, ghostScore: $ghostScore, truthScore: $truthScore, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employerId, employerId) ||
                other.employerId == employerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.size, size) || other.size == size) &&
            const DeepCollectionEquality()
                .equals(other._cultureTags, _cultureTags) &&
            const DeepCollectionEquality()
                .equals(other._techStack, _techStack) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.ghostScore, ghostScore) ||
                other.ghostScore == ghostScore) &&
            const DeepCollectionEquality()
                .equals(other._truthScore, _truthScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      employerId,
      name,
      logoUrl,
      size,
      const DeepCollectionEquality().hash(_cultureTags),
      const DeepCollectionEquality().hash(_techStack),
      description,
      website,
      ghostScore,
      const DeepCollectionEquality().hash(_truthScore),
      createdAt);

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyModelImplCopyWith<_$CompanyModelImpl> get copyWith =>
      __$$CompanyModelImplCopyWithImpl<_$CompanyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyModelImplToJson(
      this,
    );
  }
}

abstract class _CompanyModel implements CompanyModel {
  const factory _CompanyModel(
      {required final String id,
      required final String employerId,
      required final String name,
      final String? logoUrl,
      final String? size,
      final List<String> cultureTags,
      final List<String> techStack,
      final String? description,
      final String? website,
      final int ghostScore,
      final Map<String, dynamic>? truthScore,
      required final DateTime createdAt}) = _$CompanyModelImpl;

  factory _CompanyModel.fromJson(Map<String, dynamic> json) =
      _$CompanyModelImpl.fromJson;

  @override
  String get id;
  @override
  String get employerId;
  @override
  String get name;
  @override
  String? get logoUrl;
  @override
  String? get size;
  @override
  List<String> get cultureTags;
  @override
  List<String> get techStack;
  @override
  String? get description;
  @override
  String? get website;
  @override
  int get ghostScore;
  @override
  Map<String, dynamic>? get truthScore;
  @override
  DateTime get createdAt;

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyModelImplCopyWith<_$CompanyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
