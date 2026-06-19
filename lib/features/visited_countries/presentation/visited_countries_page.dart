import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_journal_app/core/di/service_locator.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../countries/data/country_model.dart';
import '../../countries/logic/countries_cubit.dart';
import '../../countries/logic/countries_state.dart';
import '../../countries/presentation/country_display_mapper.dart';
import '../data/visited_countries_repository.dart';
import '../data/visited_country_id.dart';
import '../logic/visited_countries_cubit.dart';
import '../logic/visited_countries_state.dart';

class VisitedCountriesPage extends StatelessWidget {
  const VisitedCountriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CountriesCubit(countriesRepository: getIt())..loadAllCountries(),
        ),
        BlocProvider(
          create: (_) =>
              VisitedCountriesCubit(getIt<VisitedCountriesRepository>())
                ..watchVisitedCountries(),
        ),
      ],
      child: const VisitedCountriesView(),
    );
  }
}

class VisitedCountriesView extends StatelessWidget {
  const VisitedCountriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(translations.visitedCountries)),
      body: BlocBuilder<CountriesCubit, CountriesState>(
        builder: (context, countriesState) {
          final isLoadingCountries =
              countriesState.isLoading && countriesState.allCountries.isEmpty;

          if (isLoadingCountries) {
            return const Center(child: CircularProgressIndicator());
          }

          if (countriesState.status == CountriesStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      translations.countriesFetchFailed,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {
                        context.read<CountriesCubit>().loadAllCountries();
                      },
                      child: Text(translations.tryAgain),
                    ),
                  ],
                ),
              ),
            );
          }

          return BlocBuilder<VisitedCountriesCubit, VisitedCountriesState>(
            builder: (context, visitedState) {
              final visitedCountries = countriesState.allCountries.where((
                country,
              ) {
                final countryId = VisitedCountryId.fromCountry(country);

                return countryId != null &&
                    visitedState.visitedCountryIds.contains(countryId);
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: _VisitedCountriesCounter(
                      count: visitedCountries.length,
                    ),
                  ),
                  if (visitedCountries.isEmpty)
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            translations.noVisitedCountriesYet,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: visitedCountries.length,
                        separatorBuilder: (context, index) {
                          return const Divider(height: 1);
                        },
                        itemBuilder: (context, index) {
                          final country = visitedCountries[index];

                          final displayCountry =
                              CountryDisplayMapper.fromCountry(
                                country: country,
                                languageCode: languageCode,
                                translations: translations,
                              );

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            leading: _CountryFlag(flagUrl: country.flagUrl),
                            title: Text(
                              displayCountry.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(displayCountry.region),
                            trailing: const Icon(
                              Icons.verified_rounded,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _VisitedCountriesCounter extends StatelessWidget {
  final int count;

  const _VisitedCountriesCounter({required this.count});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.public, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                translations.visitedCountriesCount(count),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryFlag extends StatelessWidget {
  final String? flagUrl;

  const _CountryFlag({required this.flagUrl});

  @override
  Widget build(BuildContext context) {
    final url = flagUrl;

    if (url == null || url.isEmpty) {
      return _buildFallbackFlag(context);
    }

    return Container(
      width: 38,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackFlag(context);
        },
      ),
    );
  }

  Widget _buildFallbackFlag(BuildContext context) {
    return Container(
      width: 38,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
        ),
      ),
      child: Icon(
        Icons.flag,
        size: 18,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
