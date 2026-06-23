import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_day_stats.dart';

part 'profile_activity_stats.freezed.dart';

@freezed
abstract class ProfileActivityStats with _$ProfileActivityStats {
  const ProfileActivityStats._();

  const factory ProfileActivityStats({
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(0) int activeDaysCount,
    @Default(0) int photosCount,
    @Default(0) int notesCount,
    @Default(0) int visitedCountriesCount,
    @Default(<ActivityDayStats>[]) List<ActivityDayStats> dailyStats,
  }) = _ProfileActivityStats;

  bool get hasAnyActivity {
    return photosCount > 0 || notesCount > 0 || visitedCountriesCount > 0;
  }
}
