import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../data/trip_diary_entry.dart';
import '../logic/trip_diary_cubit.dart';

class TripDiaryDetailsPage extends StatelessWidget {
  final TripDiaryEntry entry;

  const TripDiaryDetailsPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    final title = _displayText(entry.title, translations.noData);
    final description = _displayText(entry.description, translations.noData);
    final countryLabel = _displayText(
      entry.countryName,
      _displayText(entry.countryCode, translations.noData),
    );
    final flagUrl = entry.countryFlagUrl?.trim();

    final date = entry.travelDate == null
        ? translations.noData
        : DateFormat.yMMMd(locale).format(entry.travelDate!);

    return Scaffold(
      appBar: AppBar(
        title: Text(translations.tripDiaryDetails),
        actions: [
          IconButton(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(date),
          const SizedBox(height: 16),
          if (flagUrl != null && flagUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                flagUrl,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return const SizedBox.shrink();
                },
              ),
            ),
          const SizedBox(height: 16),
          Wrap(
            children: [
              Chip(
                avatar: const Icon(Icons.public, size: 18),
                label: Text(countryLabel),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(description),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final translations = AppLocalizations.of(context);
    final tripDiaryCubit = context.read<TripDiaryCubit>();
    final navigator = Navigator.of(context);

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(translations.deleteTripDiaryEntry),
          content: Text(translations.deleteTripDiaryEntryConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(translations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(translations.delete),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await tripDiaryCubit.deleteEntry(entry.id);

    navigator.pop();
  }

  String _displayText(String? value, String fallback) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return fallback;
    }

    return trimmedValue;
  }
}
