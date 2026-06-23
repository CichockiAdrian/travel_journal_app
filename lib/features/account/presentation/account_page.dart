import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_journal_app/core/di/service_locator.dart';
import 'package:travel_journal_app/features/account/achievements/logic/achievements_calculator.dart';
import 'package:travel_journal_app/features/account/achievements/presentation/achievements_section.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../photo_gallery/presentation/photo_gallery_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../../trip_diary/data/trip_diary_repository.dart';
import '../../trip_diary/presentation/trip_diary_page.dart';
import '../../visited_countries/data/visited_countries_repository.dart';
import '../../visited_countries/logic/visited_countries_cubit.dart';
import '../../visited_countries/logic/visited_countries_state.dart';
import '../../visited_countries/presentation/visited_countries_page.dart';
import '../activity_statistics/logic/profile_activity_stats_calculator.dart';
import '../activity_statistics/logic/profile_activity_stats_cubit.dart';
import '../activity_statistics/presentation/profile_activity_stats_section.dart';
import '../logic/account_cubit.dart';
import '../models/account_menu_item.dart';
import '../models/account_menu_items.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AccountCubit(authRepository: getIt())..loadUserEmail(),
        ),
        BlocProvider(
          create: (_) =>
              VisitedCountriesCubit(getIt())..watchVisitedCountries(),
        ),
        BlocProvider(
          create: (_) => ProfileActivityStatsCubit(
            getIt<TripDiaryRepository>(),
            getIt<VisitedCountriesRepository>(),
            getIt<ProfileActivityStatsCalculator>(),
          )..watchStats(),
        ),
      ],
      child: const AccountView(),
    );
  }
}

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(translations.account)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 12),

              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 36,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translations.user,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.email.isEmpty
                              ? translations.noData
                              : state.email,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const ProfileActivityStatsSection(),
              const SizedBox(height: 20),
              AchievementsSection(calculator: getIt<AchievementsCalculator>()),
              const SizedBox(height: 20),

              ...accountMenuItems.map((item) {
                return Card(
                  child: ListTile(
                    leading: Icon(item.icon),
                    title: Text(_getMenuTitle(translations, item.type)),
                    subtitle: Text(_getMenuSubtitle(translations, item.type)),
                    trailing: _AccountMenuItemTrailing(type: item.type),
                    onTap: () => _handleMenuItemTap(context, item.type),
                  ),
                );
              }),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () => context.read<AccountCubit>().logout(),
                icon: const Icon(Icons.logout),
                label: state.isLoading
                    ? Text(translations.loggingOut)
                    : Text(translations.logout),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMenuTitle(
    AppLocalizations translations,
    AccountMenuItemType type,
  ) {
    switch (type) {
      case AccountMenuItemType.visitedCountries:
        return translations.visitedCountries;
      case AccountMenuItemType.travelJournal:
        return translations.travelJournal;
      case AccountMenuItemType.photos:
        return translations.photos;
      case AccountMenuItemType.settings:
        return translations.settings;
    }
  }

  String _getMenuSubtitle(
    AppLocalizations translations,
    AccountMenuItemType type,
  ) {
    switch (type) {
      case AccountMenuItemType.visitedCountries:
        return translations.visitedCountriesSubtitle;
      case AccountMenuItemType.travelJournal:
        return translations.travelJournalSubtitle;
      case AccountMenuItemType.photos:
        return translations.photosSubtitle;
      case AccountMenuItemType.settings:
        return translations.settingsSubtitle;
    }
  }

  void _handleMenuItemTap(BuildContext context, AccountMenuItemType type) {
    switch (type) {
      case AccountMenuItemType.settings:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
        break;

      case AccountMenuItemType.visitedCountries:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VisitedCountriesPage()),
        );
        break;

      case AccountMenuItemType.travelJournal:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TripDiaryPage()),
        );
        break;

      case AccountMenuItemType.photos:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PhotoGalleryPage()),
        );
        break;
    }
  }
}

class _AccountMenuItemTrailing extends StatelessWidget {
  final AccountMenuItemType type;

  const _AccountMenuItemTrailing({required this.type});

  @override
  Widget build(BuildContext context) {
    if (type != AccountMenuItemType.visitedCountries) {
      return const Icon(Icons.chevron_right);
    }

    return BlocBuilder<VisitedCountriesCubit, VisitedCountriesState>(
      builder: (context, state) {
        final count = state.visitedCountries.length;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        );
      },
    );
  }
}
