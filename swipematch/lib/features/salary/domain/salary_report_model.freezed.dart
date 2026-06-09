// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salary_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SalaryReportModel _$SalaryReportModelFromJson(Map<String, dynamic> json) {
  return _SalaryReportModel.fromJson(json);
}

/// @nodoc
mixin _$SalaryReportModel {
  String get id => throw _privateConstructorUsedError;
  String? get reporterId => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String get roleTitle => throw _privateConstructorUsedError;
  int get salary => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SalaryReportModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalaryReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalaryReportModelCopyWith<SalaryReportModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalaryReportModelCopyWith<$Res> {
  factory $SalaryReportModelCopyWith(
          SalaryReportModel value, $Res Function(SalaryReportModel) then) =
      _$SalaryReportModelCopyWithImpl<$Res, SalaryReportModel>;
  @useResult
  $Res call(
      {String id,
      String? reporterId,
      String companyName,
      String roleTitle,
      int salary,
      String currency,
      String? city,
      String? country,
      bool verified,
      DateTime createdAt});
}

/// @nodoc
class _$SalaryReportModelCopyWithImpl<$Res, $Val extends SalaryReportModel>
    implements $SalaryReportModelCopyWith<$Res> {
  _$SalaryReportModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalaryReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = freezed,
    Object? companyName = null,
    Object? roleTitle = null,
    Object? salary = null,
    Object? currency = null,
    Object? city = freezed,
    Object? country = freezed,
    Object? verified = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reporterId: freezed == reporterId
          ? _value.reporterId
          : reporterId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      roleTitle: null == roleTitle
          ? _value.roleTitle
          : roleTitle // ignore: cast_nullable_to_non_nullable
              as String,
      salary: null == salary
          ? _value.salary
          : salary // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalaryReportModelImplCopyWith<$Res>
    implements $SalaryReportModelCopyWith<$Res> {
  factory _$$SalaryReportModelImplCopyWith(_$SalaryReportModelImpl value,
          $Res Function(_$SalaryReportModelImpl) then) =
      __$$SalaryReportModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? reporterId,
      String companyName,
      String roleTitle,
      int salary,
      String currency,
      String? city,
      String? country,
      bool verified,
      DateTime createdAt});
}

/// @nodoc
class __$$SalaryReportModelImplCopyWithImpl<$Res>
    extends _$SalaryReportModelCopyWithImpl<$Res, _$SalaryReportModelImpl>
    implements _$$SalaryReportModelImplCopyWith<$Res> {
  __$$SalaryReportModelImplCopyWithImpl(_$SalaryReportModelImpl _value,
      $Res Function(_$SalaryReportModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalaryReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = freezed,
    Object? companyName = null,
    Object? roleTitle = null,
    Object? salary = null,
    Object? currency = null,
    Object? city = freezed,
    Object? country = freezed,
    Object? verified = null,
    Object? createdAt = null,
  }) {
    return _then(_$SalaryReportModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reporterId: freezed == reporterId
          ? _value.reporterId
          : reporterId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      roleTitle: null == roleTitle
          ? _value.roleTitle
          : roleTitle // ignore: cast_nullable_to_non_nullable
              as String,
      salary: null == salary
          ? _value.salary
          : salary // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalaryReportModelImpl implements _SalaryReportModel {
  const _$SalaryReportModelImpl(
      {required this.id,
      this.reporterId,
      required this.companyName,
      required this.roleTitle,
      required this.salary,
      this.currency = 'USD',
      this.city,
      this.country,
      this.verified = false,
      required this.createdAt});

  factory _$SalaryReportModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalaryReportModelImplFromJson(json);

  @override
  final String id;
  @override
  final String? reporterId;
  @override
  final String companyName;
  @override
  final String roleTitle;
  @override
  final int salary;
  @override
  @JsonKey()
  final String currency;
  @override
  final String? city;
  @override
  final String? country;
  @override
  @JsonKey()
  final bool verified;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SalaryReportModel(id: $id, reporterId: $reporterId, companyName: $companyName, roleTitle: $roleTitle, salary: $salary, currency: $currency, city: $city, country: $country, verified: $verified, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalaryReportModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reporterId, reporterId) ||
                other.reporterId == reporterId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.roleTitle, roleTitle) ||
                other.roleTitle == roleTitle) &&
            (identical(other.salary, salary) || other.salary == salary) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, reporterId, companyName,
      roleTitle, salary, currency, city, country, verified, createdAt);

  /// Create a copy of SalaryReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalaryReportModelImplCopyWith<_$SalaryReportModelImpl> get copyWith =>
      __$$SalaryReportModelImplCopyWithImpl<_$SalaryReportModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalaryReportModelImplToJson(
      this,
    );
  }
}

abstract class _SalaryReportModel implements SalaryReportModel {
  const factory _SalaryReportModel(
      {required final String id,
      final String? reporterId,
      required final String companyName,
      required final String roleTitle,
      required final int salary,
      final String currency,
      final String? city,
      final String? country,
      final bool verified,
      required final DateTime createdAt}) = _$SalaryReportModelImpl;

  factory _SalaryReportModel.fromJson(Map<String, dynamic> json) =
      _$SalaryReportModelImpl.fromJson;

  @override
  String get id;
  @override
  String? get reporterId;
  @override
  String get companyName;
  @override
  String get roleTitle;
  @override
  int get salary;
  @override
  String get currency;
  @override
  String? get city;
  @override
  String? get country;
  @override
  bool get verified;
  @override
  DateTime get createdAt;

  /// Create a copy of SalaryReportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalaryReportModelImplCopyWith<_$SalaryReportModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalaryAggregate _$SalaryAggregateFromJson(Map<String, dynamic> json) {
  return _SalaryAggregate.fromJson(json);
}

/// @nodoc
mixin _$SalaryAggregate {
  int get count => throw _privateConstructorUsedError;
  int get min => throw _privateConstructorUsedError;
  int get max => throw _privateConstructorUsedError;
  int get median => throw _privateConstructorUsedError;
  int get p25 => throw _privateConstructorUsedError;
  int get p75 => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  List<SalaryReportModel> get sampleReports =>
      throw _privateConstructorUsedError;

  /// Serializes this SalaryAggregate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalaryAggregate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalaryAggregateCopyWith<SalaryAggregate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalaryAggregateCopyWith<$Res> {
  factory $SalaryAggregateCopyWith(
          SalaryAggregate value, $Res Function(SalaryAggregate) then) =
      _$SalaryAggregateCopyWithImpl<$Res, SalaryAggregate>;
  @useResult
  $Res call(
      {int count,
      int min,
      int max,
      int median,
      int p25,
      int p75,
      String currency,
      List<SalaryReportModel> sampleReports});
}

/// @nodoc
class _$SalaryAggregateCopyWithImpl<$Res, $Val extends SalaryAggregate>
    implements $SalaryAggregateCopyWith<$Res> {
  _$SalaryAggregateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalaryAggregate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? min = null,
    Object? max = null,
    Object? median = null,
    Object? p25 = null,
    Object? p75 = null,
    Object? currency = null,
    Object? sampleReports = null,
  }) {
    return _then(_value.copyWith(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as int,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as int,
      median: null == median
          ? _value.median
          : median // ignore: cast_nullable_to_non_nullable
              as int,
      p25: null == p25
          ? _value.p25
          : p25 // ignore: cast_nullable_to_non_nullable
              as int,
      p75: null == p75
          ? _value.p75
          : p75 // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      sampleReports: null == sampleReports
          ? _value.sampleReports
          : sampleReports // ignore: cast_nullable_to_non_nullable
              as List<SalaryReportModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalaryAggregateImplCopyWith<$Res>
    implements $SalaryAggregateCopyWith<$Res> {
  factory _$$SalaryAggregateImplCopyWith(_$SalaryAggregateImpl value,
          $Res Function(_$SalaryAggregateImpl) then) =
      __$$SalaryAggregateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int count,
      int min,
      int max,
      int median,
      int p25,
      int p75,
      String currency,
      List<SalaryReportModel> sampleReports});
}

/// @nodoc
class __$$SalaryAggregateImplCopyWithImpl<$Res>
    extends _$SalaryAggregateCopyWithImpl<$Res, _$SalaryAggregateImpl>
    implements _$$SalaryAggregateImplCopyWith<$Res> {
  __$$SalaryAggregateImplCopyWithImpl(
      _$SalaryAggregateImpl _value, $Res Function(_$SalaryAggregateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalaryAggregate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? min = null,
    Object? max = null,
    Object? median = null,
    Object? p25 = null,
    Object? p75 = null,
    Object? currency = null,
    Object? sampleReports = null,
  }) {
    return _then(_$SalaryAggregateImpl(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as int,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as int,
      median: null == median
          ? _value.median
          : median // ignore: cast_nullable_to_non_nullable
              as int,
      p25: null == p25
          ? _value.p25
          : p25 // ignore: cast_nullable_to_non_nullable
              as int,
      p75: null == p75
          ? _value.p75
          : p75 // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      sampleReports: null == sampleReports
          ? _value._sampleReports
          : sampleReports // ignore: cast_nullable_to_non_nullable
              as List<SalaryReportModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalaryAggregateImpl implements _SalaryAggregate {
  const _$SalaryAggregateImpl(
      {required this.count,
      required this.min,
      required this.max,
      required this.median,
      required this.p25,
      required this.p75,
      this.currency = 'USD',
      final List<SalaryReportModel> sampleReports = const []})
      : _sampleReports = sampleReports;

  factory _$SalaryAggregateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalaryAggregateImplFromJson(json);

  @override
  final int count;
  @override
  final int min;
  @override
  final int max;
  @override
  final int median;
  @override
  final int p25;
  @override
  final int p75;
  @override
  @JsonKey()
  final String currency;
  final List<SalaryReportModel> _sampleReports;
  @override
  @JsonKey()
  List<SalaryReportModel> get sampleReports {
    if (_sampleReports is EqualUnmodifiableListView) return _sampleReports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sampleReports);
  }

  @override
  String toString() {
    return 'SalaryAggregate(count: $count, min: $min, max: $max, median: $median, p25: $p25, p75: $p75, currency: $currency, sampleReports: $sampleReports)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalaryAggregateImpl &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.median, median) || other.median == median) &&
            (identical(other.p25, p25) || other.p25 == p25) &&
            (identical(other.p75, p75) || other.p75 == p75) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality()
                .equals(other._sampleReports, _sampleReports));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count, min, max, median, p25,
      p75, currency, const DeepCollectionEquality().hash(_sampleReports));

  /// Create a copy of SalaryAggregate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalaryAggregateImplCopyWith<_$SalaryAggregateImpl> get copyWith =>
      __$$SalaryAggregateImplCopyWithImpl<_$SalaryAggregateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalaryAggregateImplToJson(
      this,
    );
  }
}

abstract class _SalaryAggregate implements SalaryAggregate {
  const factory _SalaryAggregate(
      {required final int count,
      required final int min,
      required final int max,
      required final int median,
      required final int p25,
      required final int p75,
      final String currency,
      final List<SalaryReportModel> sampleReports}) = _$SalaryAggregateImpl;

  factory _SalaryAggregate.fromJson(Map<String, dynamic> json) =
      _$SalaryAggregateImpl.fromJson;

  @override
  int get count;
  @override
  int get min;
  @override
  int get max;
  @override
  int get median;
  @override
  int get p25;
  @override
  int get p75;
  @override
  String get currency;
  @override
  List<SalaryReportModel> get sampleReports;

  /// Create a copy of SalaryAggregate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalaryAggregateImplCopyWith<_$SalaryAggregateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
