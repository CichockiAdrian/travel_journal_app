import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../visited_countries/data/visited_country_id.dart';
import '../../visited_countries/logic/visited_countries_cubit.dart';
import '../../visited_countries/logic/visited_countries_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'country_display_mapper.dart';
import '../data/country_model.dart';

class CountryBottomSheet extends StatelessWidget {
  final CountryModel country;

  const CountryBottomSheet({required this.country, super.key});

  @override
  Widget build(BuildContext context) {
    final flagUrl = country.flagUrl;
    final translations = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    final displayCountry = CountryDisplayMapper.fromCountry(
      country: country,
      languageCode: languageCode,
      translations: translations,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BottomSheetFlag(flagUrl: flagUrl),
          const SizedBox(height: 12),
          BlocBuilder<VisitedCountriesCubit, VisitedCountriesState>(
            builder: (context, state) {
              final countryId = VisitedCountryId.fromCountry(country);
              final isVisited =
                  countryId != null &&
                  state.visitedCountryIds.contains(countryId);

              if (!isVisited) {
                return const SizedBox.shrink();
              }

              return const Padding(
                padding: EdgeInsets.only(top: 10),
                child: _VisitedStatusBadge(),
              );
            },
          ),
          const SizedBox(height: 20),
          _InfoRow(label: translations.capital, value: displayCountry.capital),
          _InfoRow(label: translations.region, value: displayCountry.region),
          _InfoRow(
            label: translations.population,
            value: country.population?.toString() ?? translations.noData,
          ),
          _InfoRow(
            label: translations.coordinates,
            value: country.latitude != null && country.longitude != null
                ? '${country.latitude}, ${country.longitude}'
                : translations.noData,
          ),
          const SizedBox(height: 24),
          BlocBuilder<VisitedCountriesCubit, VisitedCountriesState>(
            builder: (context, state) {
              final countryId = VisitedCountryId.fromCountry(country);
              final isVisited =
                  countryId != null &&
                  state.visitedCountryIds.contains(countryId);

              final colorScheme = Theme.of(context).colorScheme;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      style: isVisited
                          ? FilledButton.styleFrom(
                              backgroundColor: colorScheme.primaryContainer,
                              foregroundColor: colorScheme.onPrimaryContainer,
                            )
                          : null,
                      onPressed:
                          countryId == null || state.isUpdatingVisitedCountry
                          ? null
                          : () {
                              context
                                  .read<VisitedCountriesCubit>()
                                  .toggleVisitedCountry(country);
                            },
                      icon: Icon(
                        isVisited
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                      ),
                      label: Text(
                        isVisited
                            ? translations.removeFromVisited
                            : translations.markAsVisited,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _VisitedStatusBadge extends StatelessWidget {
  const _VisitedStatusBadge();

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_rounded,
            size: 20,
            color: colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 10),
          Text(
            translations.visited,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSheetFlag extends StatelessWidget {
  final String? flagUrl;

  const _BottomSheetFlag({required this.flagUrl});

  @override
  Widget build(BuildContext context) {
    final url = flagUrl;

    if (url == null || url.isEmpty) {
      return _buildFallbackFlag(context);
    }

    return Container(
      width: 72,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
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
      width: 72,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
        ),
      ),
      child: Icon(
        Icons.flag,
        size: 36,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
