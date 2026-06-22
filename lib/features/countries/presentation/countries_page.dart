import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_journal_app/core/di/service_locator.dart';

import '../../../l10n/generated/app_localizations.dart';
import 'country_display_mapper.dart';
import '../data/country_model.dart';
import '../logic/countries_cubit.dart';
import '../logic/countries_state.dart';
import 'country_bottom_sheet.dart';
import '../../visited_countries/data/visited_countries_repository.dart';
import '../../visited_countries/data/visited_country_id.dart';
import '../../visited_countries/logic/visited_countries_cubit.dart';
import '../../visited_countries/logic/visited_countries_state.dart';

class CountriesPage extends StatelessWidget {
  const CountriesPage({super.key});

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
      child: const CountriesView(),
    );
  }
}

class CountriesView extends StatelessWidget {
  const CountriesView({super.key});

  void showCountryDetails(BuildContext context, CountryModel country) {
    final visitedCountriesCubit = context.read<VisitedCountriesCubit>();

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return BlocProvider.value(
          value: visitedCountriesCubit,
          child: CountryBottomSheet(country: country),
        );
      },
    );
  }

  bool onScrollNotification(
    BuildContext context,
    ScrollNotification notification,
  ) {
    if (notification.metrics.pixels >
        notification.metrics.maxScrollExtent - 250) {
      context.read<CountriesCubit>().loadMore();
    }

    return false;
  }

  String getVisitedCountriesErrorMessage(
    BuildContext context,
    VisitedCountriesFailureType type,
  ) {
    final translations = AppLocalizations.of(context);

    switch (type) {
      case VisitedCountriesFailureType.notAuthenticated:
        return translations.signInToSyncVisitedCountries;
      case VisitedCountriesFailureType.missingCountryId:
        return translations.countryCannotBeMarkedAsVisited;
      case VisitedCountriesFailureType.unknown:
        return translations.visitedCountriesSyncFailed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return MultiBlocListener(
      listeners: [
        BlocListener<CountriesCubit, CountriesState>(
          listenWhen: (previous, current) {
            return previous.errorMessage != current.errorMessage &&
                current.errorMessage != null;
          },
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<CountriesCubit>().clearError();
          },
        ),
        BlocListener<VisitedCountriesCubit, VisitedCountriesState>(
          listenWhen: (previous, current) {
            return previous.failureType != current.failureType &&
                current.failureType != null;
          },
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  getVisitedCountriesErrorMessage(context, state.failureType!),
                ),
              ),
            );

            context.read<VisitedCountriesCubit>().clearFailure();
          },
        ),
      ],
      child: BlocBuilder<CountriesCubit, CountriesState>(
        builder: (context, state) {
          final showInitialLoader =
              state.isLoading && state.visibleCountries.isEmpty;

          return Scaffold(
            appBar: AppBar(title: Text(translations.countries)),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) {
                      context.read<CountriesCubit>().searchCountries(value);
                    },
                    decoration: InputDecoration(
                      hintText: translations.searchCountry,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                if (showInitialLoader)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.status == CountriesStatus.failure)
                  Expanded(
                    child: Center(
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
                                context
                                    .read<CountriesCubit>()
                                    .loadAllCountries();
                              },
                              child: Text(translations.tryAgain),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (state.visibleCountries.isEmpty)
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          state.allCountries.isEmpty
                              ? translations.noCountriesFound
                              : translations.noSearchResults,
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
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        return onScrollNotification(context, notification);
                      },
                      child: ListView.separated(
                        itemCount: state.visibleCountries.length + 1,
                        separatorBuilder: (context, index) {
                          return const Divider(height: 1);
                        },
                        itemBuilder: (context, index) {
                          if (index == state.visibleCountries.length) {
                            if (!state.hasMore) {
                              return const SizedBox(height: 24);
                            }

                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final country = state.visibleCountries[index];

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
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              displayCountry.region,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            trailing:
                                BlocBuilder<
                                  VisitedCountriesCubit,
                                  VisitedCountriesState
                                >(
                                  builder: (context, visitedState) {
                                    final countryId =
                                        VisitedCountryId.fromCountry(country);
                                    final isVisited =
                                        countryId != null &&
                                        visitedState.visitedCountryIds.contains(
                                          countryId,
                                        );

                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isVisited) ...[
                                          Icon(
                                            Icons.verified_rounded,
                                            size: 18,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 14),
                                        ],
                                        Icon(
                                          Icons.chevron_right,
                                          size: 20,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                            onTap: () => showCountryDetails(context, country),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
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
