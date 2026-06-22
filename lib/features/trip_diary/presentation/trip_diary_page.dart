import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/service_locator.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../countries/data/countries_repository.dart';
import '../../visited_countries/data/visited_countries_repository.dart';
import '../data/trip_diary_entry.dart';
import '../data/trip_diary_repository.dart';
import '../logic/trip_diary_cubit.dart';
import '../logic/trip_diary_state.dart';
import 'trip_diary_details_page.dart';
import 'trip_diary_form_page.dart';

class TripDiaryPage extends StatelessWidget {
  const TripDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TripDiaryCubit(tripDiaryRepository: getIt<TripDiaryRepository>())
            ..watchEntries(),
      child: const TripDiaryView(),
    );
  }
}

class TripDiaryView extends StatelessWidget {
  const TripDiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(translations.travelJournal)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<TripDiaryCubit>(),
                  child: TripDiaryFormPage(
                    countriesRepository: getIt<CountriesRepository>(),
                    visitedCountriesRepository:
                        getIt<VisitedCountriesRepository>(),
                  ),
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TripDiaryCubit, TripDiaryState>(
        builder: (context, state) {
          if (state.status == TripDiaryStatus.loading ||
              state.status == TripDiaryStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TripDiaryStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      translations.tripDiarySyncFailed,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () =>
                          context.read<TripDiaryCubit>().watchEntries(),
                      child: Text(translations.tryAgain),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  translations.tripDiaryEmpty,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.entries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final entry = state.entries[index];

              return _TripDiaryEntryCard(
                entry: entry,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return BlocProvider.value(
                          value: context.read<TripDiaryCubit>(),
                          child: TripDiaryDetailsPage(entry: entry),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _TripDiaryEntryCard extends StatelessWidget {
  final TripDiaryEntry entry;
  final VoidCallback onTap;

  const _TripDiaryEntryCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    final title = _displayText(entry.title, translations.noData);
    final description = _displayText(entry.description, translations.noData);

    final date = entry.travelDate == null
        ? translations.noData
        : DateFormat.yMMMd(locale).format(entry.travelDate!);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _CountryThumbnail(flagUrl: entry.countryFlagUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(date, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  String _displayText(String? value, String fallback) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return fallback;
    }

    return trimmedValue;
  }
}

class _CountryThumbnail extends StatelessWidget {
  final String? flagUrl;

  const _CountryThumbnail({required this.flagUrl});

  @override
  Widget build(BuildContext context) {
    final url = flagUrl?.trim();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 84,
        height: 84,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: url == null || url.isEmpty
            ? Icon(
                Icons.image_outlined,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              )
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Icon(
                    Icons.image_outlined,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  );
                },
              ),
      ),
    );
  }
}
