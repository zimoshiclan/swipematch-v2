import 'package:freezed_annotation/freezed_annotation.dart';
import 'job_model.dart';

part 'feed_state.freezed.dart';

@freezed
class FeedState with _$FeedState {
  const factory FeedState({
    @Default([]) List<JobModel> deck,
    @Default(0) int currentIndex,
    @Default(0) int sessionSwipeCount,
    @Default(false) bool showMomentumOverlay,
    @Default(false) bool isDeckEmpty,
  }) = _FeedState;
}
