import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../activity_statistics/logic/profile_activity_stats_cubit.dart';
import '../../activity_statistics/logic/profile_activity_stats_state.dart';
import '../logic/achievements_calculator.dart';
import 'achievement_card.dart';

class AchievementsSection extends StatelessWidget {
  final AchievementsCalculator calculator;

  const AchievementsSection({super.key, required this.calculator});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return BlocBuilder<ProfileActivityStatsCubit, ProfileActivityStatsState>(
      builder: (context, state) {
        if (state.isLoading && !state.stats.hasAnyActivity) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Semantics(
                  label: translations.achievements,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }

        final achievements = calculator.calculate(state.stats);
        final unlockedCount = achievements
            .where((achievement) => achievement.isUnlocked)
            .length;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translations.achievements,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  translations.achievementsUnlockedCount(
                    unlockedCount,
                    achievements.length,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                ...achievements.map((achievement) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AchievementCard(achievement: achievement),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
