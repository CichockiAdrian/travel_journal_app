import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/profile_activity_stats.dart';

part 'profile_activity_stats_state.freezed.dart';

enum ProfileActivityStatsStatus { initial, loading, success, failure }

@freezed
abstract class ProfileActivityStatsState with _$ProfileActivityStatsState {
  const ProfileActivityStatsState._();

  const factory ProfileActivityStatsState({
    @Default(ProfileActivityStatsStatus.initial)
    ProfileActivityStatsStatus status,
    @Default(ProfileActivityStats()) ProfileActivityStats stats,
    String? errorMessage,
  }) = _ProfileActivityStatsState;

  bool get isLoading => status == ProfileActivityStatsStatus.loading;

  bool get hasFailure => status == ProfileActivityStatsStatus.failure;
}
