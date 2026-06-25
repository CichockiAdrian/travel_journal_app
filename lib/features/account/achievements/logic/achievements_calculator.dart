import '../../activity_statistics/data/profile_activity_stats.dart';
import '../data/achievement.dart';
import '../data/achievement_type.dart';

class AchievementsCalculator {
  const AchievementsCalculator();

  List<Achievement> calculate(ProfileActivityStats stats) {
    return [
      _build(
        type: AchievementType.firstPhoto,
        currentValue: stats.photosCount,
        requiredValue: 1,
      ),
      _build(
        type: AchievementType.tenPhotos,
        currentValue: stats.photosCount,
        requiredValue: 10,
      ),
      _build(
        type: AchievementType.fiftyPhotos,
        currentValue: stats.photosCount,
        requiredValue: 50,
      ),
      _build(
        type: AchievementType.firstNote,
        currentValue: stats.notesCount,
        requiredValue: 1,
      ),
      _build(
        type: AchievementType.tenNotes,
        currentValue: stats.notesCount,
        requiredValue: 10,
      ),
      _build(
        type: AchievementType.firstVisitedCountry,
        currentValue: stats.visitedCountriesCount,
        requiredValue: 1,
      ),
      _build(
        type: AchievementType.fiveVisitedCountries,
        currentValue: stats.visitedCountriesCount,
        requiredValue: 5,
      ),
      _build(
        type: AchievementType.twentyVisitedCountries,
        currentValue: stats.visitedCountriesCount,
        requiredValue: 20,
      ),
      _build(
        type: AchievementType.threeDayStreak,
        currentValue: stats.currentStreak,
        requiredValue: 3,
      ),
      _build(
        type: AchievementType.sevenDayStreak,
        currentValue: stats.currentStreak,
        requiredValue: 7,
      ),
      _build(
        type: AchievementType.thirtyDayStreak,
        currentValue: stats.currentStreak,
        requiredValue: 30,
      ),
      _build(
        type: AchievementType.sevenActiveDays,
        currentValue: stats.activeDaysCount,
        requiredValue: 7,
      ),
      _build(
        type: AchievementType.thirtyActiveDays,
        currentValue: stats.activeDaysCount,
        requiredValue: 30,
      ),
    ];
  }

  Achievement _build({
    required AchievementType type,
    required int currentValue,
    required int requiredValue,
  }) {
    return Achievement(
      type: type,
      currentValue: currentValue,
      requiredValue: requiredValue,
    );
  }
}
