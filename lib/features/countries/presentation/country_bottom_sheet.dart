import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../data/country_model.dart';

class CountryBottomSheet extends StatelessWidget {
  final CountryModel country;

  const CountryBottomSheet({required this.country, super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final flagUrl = country.flagUrl;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BottomSheetFlag(flagUrl: flagUrl),
          const SizedBox(height: 12),
          Text(
            country.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _InfoRow(
            label: translations.capital,
            value: country.capital ?? translations.noData,
          ),
          _InfoRow(label: translations.region, value: country.region),
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
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: () {
                debugPrint(translations.markedAsVisited(country.name));

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(translations.markedAsVisited(country.name)),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: Text(translations.markAsVisited),
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
