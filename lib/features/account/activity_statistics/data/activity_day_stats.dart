import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_day_stats.freezed.dart';

@freezed
abstract class ActivityDayStats with _$ActivityDayStats {
  const ActivityDayStats._();

  const factory ActivityDayStats({
    required DateTime date,
    @Default(0) int photosCount,
    @Default(0) int notesCount,
    @Default(0) int visitedCountriesCount,
  }) = _ActivityDayStats;

  int get totalActivities => photosCount + notesCount + visitedCountriesCount;

  bool get isActive => totalActivities > 0;
}
