import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/generated/app_localizations.dart';
import '../data/activity_day_stats.dart';
import '../logic/profile_activity_stats_cubit.dart';
import '../logic/profile_activity_stats_state.dart';

class ProfileActivityStatsSection extends StatelessWidget {
  const ProfileActivityStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return BlocBuilder<ProfileActivityStatsCubit, ProfileActivityStatsState>(
      builder: (context, state) {
        if (state.isLoading &&
            state.status == ProfileActivityStatsStatus.loading &&
            !state.stats.hasAnyActivity) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Semantics(
                  label: translations.profileActivityStats,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }

        if (state.hasFailure) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(translations.profileActivityStatsSyncFailed),
                  ),
                ],
              ),
            ),
          );
        }

        final stats = state.stats;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translations.profileActivityStats,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.8,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    _ActivityStatTile(
                      icon: Icons.local_fire_department,
                      label: translations.currentActivityStreak,
                      value: translations.daysCount(stats.currentStreak),
                    ),
                    _ActivityStatTile(
                      icon: Icons.emoji_events,
                      label: translations.longestActivityStreak,
                      value: translations.daysCount(stats.longestStreak),
                    ),
                    _ActivityStatTile(
                      icon: Icons.calendar_today,
                      label: translations.activeDays,
                      value: translations.daysCount(stats.activeDaysCount),
                    ),
                    _ActivityStatTile(
                      icon: Icons.photo_camera,
                      label: translations.addedPhotos,
                      value: stats.photosCount.toString(),
                    ),
                    _ActivityStatTile(
                      icon: Icons.edit_note,
                      label: translations.addedNotes,
                      value: stats.notesCount.toString(),
                    ),
                    _ActivityStatTile(
                      icon: Icons.public,
                      label: translations.visitedCountries,
                      value: stats.visitedCountriesCount.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  translations.activityCalendar,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _ActivityCalendar(days: stats.dailyStats),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActivityStatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ActivityStatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCalendar extends StatelessWidget {
  final List<ActivityDayStats> days;

  const _ActivityCalendar({required this.days});

  static const double _cellSize = 22;
  static const double _spacing = 6;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();

    if (days.isEmpty) {
      return Text(
        translations.noActivityYet,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    final firstDay = days.first.date;
    final monthLabel = DateFormat.yMMMM(locale).format(firstDay);
    final maxActivities = days
        .map((day) => day.totalActivities)
        .fold<int>(0, max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          monthLabel,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: _spacing,
          runSpacing: _spacing,
          children: [
            ...days.map((day) {
              final intensity = maxActivities == 0
                  ? 0.0
                  : day.totalActivities / maxActivities;

              final activeColor = Color.lerp(
                colorScheme.primaryContainer,
                colorScheme.primary,
                intensity.clamp(0.25, 1.0).toDouble(),
              );

              final backgroundColor = day.isActive
                  ? activeColor
                  : colorScheme.surfaceContainerHighest;

              return Tooltip(
                message: DateFormat.yMd(locale).format(day.date),
                child: Container(
                  width: _cellSize,
                  height: _cellSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Text(
                    day.date.day.toString(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: day.isActive
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                      fontSize: 9,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
