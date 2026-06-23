import 'package:freezed_annotation/freezed_annotation.dart';

import 'achievement_type.dart';

part 'achievement.freezed.dart';

@freezed
abstract class Achievement with _$Achievement {
  const Achievement._();

  const factory Achievement({
    required AchievementType type,
    required int currentValue,
    required int requiredValue,
  }) = _Achievement;

  bool get isUnlocked => currentValue >= requiredValue;

  double get progress {
    if (requiredValue <= 0) return 0;

    final value = currentValue / requiredValue;

    if (value < 0) return 0;
    if (value > 1) return 1;

    return value;
  }
}
