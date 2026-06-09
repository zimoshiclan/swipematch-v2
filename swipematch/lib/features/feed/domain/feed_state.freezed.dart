// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FeedState {
  List<JobModel> get deck => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;
  int get sessionSwipeCount => throw _privateConstructorUsedError;
  bool get showMomentumOverlay => throw _privateConstructorUsedError;
  bool get isDeckEmpty => throw _privateConstructorUsedError;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedStateCopyWith<FeedState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedStateCopyWith<$Res> {
  factory $FeedStateCopyWith(FeedState value, $Res Function(FeedState) then) =
      _$FeedStateCopyWithImpl<$Res, FeedState>;
  @useResult
  $Res call(
      {List<JobModel> deck,
      int currentIndex,
      int sessionSwipeCount,
      bool showMomentumOverlay,
      bool isDeckEmpty});
}

/// @nodoc
class _$FeedStateCopyWithImpl<$Res, $Val extends FeedState>
    implements $FeedStateCopyWith<$Res> {
  _$FeedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deck = null,
    Object? currentIndex = null,
    Object? sessionSwipeCount = null,
    Object? showMomentumOverlay = null,
    Object? isDeckEmpty = null,
  }) {
    return _then(_value.copyWith(
      deck: null == deck
          ? _value.deck
          : deck // ignore: cast_nullable_to_non_nullable
              as List<JobModel>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      sessionSwipeCount: null == sessionSwipeCount
          ? _value.sessionSwipeCount
          : sessionSwipeCount // ignore: cast_nullable_to_non_nullable
              as int,
      showMomentumOverlay: null == showMomentumOverlay
          ? _value.showMomentumOverlay
          : showMomentumOverlay // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeckEmpty: null == isDeckEmpty
          ? _value.isDeckEmpty
          : isDeckEmpty // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedStateImplCopyWith<$Res>
    implements $FeedStateCopyWith<$Res> {
  factory _$$FeedStateImplCopyWith(
          _$FeedStateImpl value, $Res Function(_$FeedStateImpl) then) =
      __$$FeedStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<JobModel> deck,
      int currentIndex,
      int sessionSwipeCount,
      bool showMomentumOverlay,
      bool isDeckEmpty});
}

/// @nodoc
class __$$FeedStateImplCopyWithImpl<$Res>
    extends _$FeedStateCopyWithImpl<$Res, _$FeedStateImpl>
    implements _$$FeedStateImplCopyWith<$Res> {
  __$$FeedStateImplCopyWithImpl(
      _$FeedStateImpl _value, $Res Function(_$FeedStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deck = null,
    Object? currentIndex = null,
    Object? sessionSwipeCount = null,
    Object? showMomentumOverlay = null,
    Object? isDeckEmpty = null,
  }) {
    return _then(_$FeedStateImpl(
      deck: null == deck
          ? _value._deck
          : deck // ignore: cast_nullable_to_non_nullable
              as List<JobModel>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      sessionSwipeCount: null == sessionSwipeCount
          ? _value.sessionSwipeCount
          : sessionSwipeCount // ignore: cast_nullable_to_non_nullable
              as int,
      showMomentumOverlay: null == showMomentumOverlay
          ? _value.showMomentumOverlay
          : showMomentumOverlay // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeckEmpty: null == isDeckEmpty
          ? _value.isDeckEmpty
          : isDeckEmpty // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$FeedStateImpl implements _FeedState {
  const _$FeedStateImpl(
      {final List<JobModel> deck = const [],
      this.currentIndex = 0,
      this.sessionSwipeCount = 0,
      this.showMomentumOverlay = false,
      this.isDeckEmpty = false})
      : _deck = deck;

  final List<JobModel> _deck;
  @override
  @JsonKey()
  List<JobModel> get deck {
    if (_deck is EqualUnmodifiableListView) return _deck;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deck);
  }

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final int sessionSwipeCount;
  @override
  @JsonKey()
  final bool showMomentumOverlay;
  @override
  @JsonKey()
  final bool isDeckEmpty;

  @override
  String toString() {
    return 'FeedState(deck: $deck, currentIndex: $currentIndex, sessionSwipeCount: $sessionSwipeCount, showMomentumOverlay: $showMomentumOverlay, isDeckEmpty: $isDeckEmpty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedStateImpl &&
            const DeepCollectionEquality().equals(other._deck, _deck) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.sessionSwipeCount, sessionSwipeCount) ||
                other.sessionSwipeCount == sessionSwipeCount) &&
            (identical(other.showMomentumOverlay, showMomentumOverlay) ||
                other.showMomentumOverlay == showMomentumOverlay) &&
            (identical(other.isDeckEmpty, isDeckEmpty) ||
                other.isDeckEmpty == isDeckEmpty));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_deck),
      currentIndex,
      sessionSwipeCount,
      showMomentumOverlay,
      isDeckEmpty);

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedStateImplCopyWith<_$FeedStateImpl> get copyWith =>
      __$$FeedStateImplCopyWithImpl<_$FeedStateImpl>(this, _$identity);
}

abstract class _FeedState implements FeedState {
  const factory _FeedState(
      {final List<JobModel> deck,
      final int currentIndex,
      final int sessionSwipeCount,
      final bool showMomentumOverlay,
      final bool isDeckEmpty}) = _$FeedStateImpl;

  @override
  List<JobModel> get deck;
  @override
  int get currentIndex;
  @override
  int get sessionSwipeCount;
  @override
  bool get showMomentumOverlay;
  @override
  bool get isDeckEmpty;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedStateImplCopyWith<_$FeedStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
