import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../data/achievement.dart';
import '../data/achievement_type.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final title = _getTitle(translations, achievement.type);
    final description = _getDescription(translations, achievement.type);
    final icon = _getIcon(achievement.type);

    final statusColor = achievement.isUnlocked
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: achievement.isUnlocked
              ? colorScheme.primary
              : colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: achievement.isUnlocked
                ? colorScheme.primaryContainer
                : colorScheme.surface,
            child: Icon(
              icon,
              color: achievement.isUnlocked
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: achievement.progress,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(999),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      translations.achievementProgress(
                        achievement.currentValue,
                        achievement.requiredValue,
                      ),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const Spacer(),
                    Text(
                      achievement.isUnlocked
                          ? translations.achievementUnlocked
                          : translations.achievementInProgress,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(AchievementType type) {
    if (type.isPhotoAchievement) return Icons.photo_camera;
    if (type.isNoteAchievement) return Icons.edit_note;
    if (type.isCountryAchievement) return Icons.public;
    if (type.isStreakAchievement) return Icons.local_fire_department;
    if (type.isActiveDaysAchievement) return Icons.calendar_month;

    return Icons.emoji_events;
  }

  String _getTitle(AppLocalizations translations, AchievementType type) {
    switch (type) {
      case AchievementType.firstPhoto:
        return translations.achievementFirstPhotoTitle;
      case AchievementType.tenPhotos:
        return translations.achievementTenPhotosTitle;
      case AchievementType.fiftyPhotos:
        return translations.achievementFiftyPhotosTitle;
      case AchievementType.firstNote:
        return translations.achievementFirstNoteTitle;
      case AchievementType.tenNotes:
        return translations.achievementTenNotesTitle;
      case AchievementType.firstVisitedCountry:
        return translations.achievementFirstVisitedCountryTitle;
      case AchievementType.fiveVisitedCountries:
        return translations.achievementFiveVisitedCountriesTitle;
      case AchievementType.twentyVisitedCountries:
        return translations.achievementTwentyVisitedCountriesTitle;
      case AchievementType.threeDayStreak:
        return translations.achievementThreeDayStreakTitle;
      case AchievementType.sevenDayStreak:
        return translations.achievementSevenDayStreakTitle;
      case AchievementType.thirtyDayStreak:
        return translations.achievementThirtyDayStreakTitle;
      case AchievementType.sevenActiveDays:
        return translations.achievementSevenActiveDaysTitle;
      case AchievementType.thirtyActiveDays:
        return translations.achievementThirtyActiveDaysTitle;
    }
  }

  String _getDescription(AppLocalizations translations, AchievementType type) {
    switch (type) {
      case AchievementType.firstPhoto:
        return translations.achievementFirstPhotoDescription;
      case AchievementType.tenPhotos:
        return translations.achievementTenPhotosDescription;
      case AchievementType.fiftyPhotos:
        return translations.achievementFiftyPhotosDescription;
      case AchievementType.firstNote:
        return translations.achievementFirstNoteDescription;
      case AchievementType.tenNotes:
        return translations.achievementTenNotesDescription;
      case AchievementType.firstVisitedCountry:
        return translations.achievementFirstVisitedCountryDescription;
      case AchievementType.fiveVisitedCountries:
        return translations.achievementFiveVisitedCountriesDescription;
      case AchievementType.twentyVisitedCountries:
        return translations.achievementTwentyVisitedCountriesDescription;
      case AchievementType.threeDayStreak:
        return translations.achievementThreeDayStreakDescription;
      case AchievementType.sevenDayStreak:
        return translations.achievementSevenDayStreakDescription;
      case AchievementType.thirtyDayStreak:
        return translations.achievementThirtyDayStreakDescription;
      case AchievementType.sevenActiveDays:
        return translations.achievementSevenActiveDaysDescription;
      case AchievementType.thirtyActiveDays:
        return translations.achievementThirtyActiveDaysDescription;
    }
  }
}
