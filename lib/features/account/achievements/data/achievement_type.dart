enum AchievementType {
  firstPhoto,
  tenPhotos,
  fiftyPhotos,
  firstNote,
  tenNotes,
  firstVisitedCountry,
  fiveVisitedCountries,
  twentyVisitedCountries,
  threeDayStreak,
  sevenDayStreak,
  thirtyDayStreak,
  sevenActiveDays,
  thirtyActiveDays,
}

extension AchievementTypeX on AchievementType {
  bool get isPhotoAchievement {
    return this == AchievementType.firstPhoto ||
        this == AchievementType.tenPhotos ||
        this == AchievementType.fiftyPhotos;
  }

  bool get isNoteAchievement {
    return this == AchievementType.firstNote ||
        this == AchievementType.tenNotes;
  }

  bool get isCountryAchievement {
    return this == AchievementType.firstVisitedCountry ||
        this == AchievementType.fiveVisitedCountries ||
        this == AchievementType.twentyVisitedCountries;
  }

  bool get isStreakAchievement {
    return this == AchievementType.threeDayStreak ||
        this == AchievementType.sevenDayStreak ||
        this == AchievementType.thirtyDayStreak;
  }

  bool get isActiveDaysAchievement {
    return this == AchievementType.sevenActiveDays ||
        this == AchievementType.thirtyActiveDays;
  }
}
