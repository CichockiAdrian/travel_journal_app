import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/trip_diary_entry.dart';

part 'trip_diary_state.freezed.dart';

enum TripDiaryStatus { initial, loading, success, failure }

@freezed
abstract class TripDiaryState with _$TripDiaryState {
  const TripDiaryState._();

  const factory TripDiaryState({
    @Default(TripDiaryStatus.initial) TripDiaryStatus status,
    @Default(<TripDiaryEntry>[]) List<TripDiaryEntry> entries,
    String? errorMessage,
  }) = _TripDiaryState;

  bool get isLoading => status == TripDiaryStatus.loading;
}
