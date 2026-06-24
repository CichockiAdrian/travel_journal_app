import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../data/planned_place_model.dart';
import '../logic/planned_places_cubit.dart';

class PlannedPlaceDetailsBottomSheet extends StatelessWidget {
  final PlannedPlaceModel place;

  const PlannedPlaceDetailsBottomSheet({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final note = place.note?.trim();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: place.isCompleted
                        ? colorScheme.tertiaryContainer
                        : colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    place.isCompleted ? Icons.check : Icons.place_outlined,
                    color: place.isCompleted
                        ? colorScheme.onTertiaryContainer
                        : colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    place.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (place.isCompleted) ...[
              const SizedBox(height: 12),
              Chip(
                label: Text(translations.plannedPlaceCompleted),
                avatar: const Icon(Icons.check, size: 18),
              ),
            ],
            if (note != null && note.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(note, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 16),
            Text(
              translations.plannedPlaceCoordinates,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '${place.latitude.toStringAsFixed(5)}, '
              '${place.longitude.toStringAsFixed(5)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  final cubit = context.read<PlannedPlacesCubit>();

                  Navigator.of(context).pop();
                  cubit.togglePlaceCompletion(place);
                },
                icon: Icon(
                  place.isCompleted
                      ? Icons.undo_outlined
                      : Icons.check_circle_outline,
                ),
                label: Text(
                  place.isCompleted
                      ? translations.plannedPlaceMarkOpen
                      : translations.plannedPlaceMarkCompleted,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  final cubit = context.read<PlannedPlacesCubit>();

                  Navigator.of(context).pop();
                  cubit.removePlace(place.id);
                },
                icon: const Icon(Icons.delete_outline),
                label: Text(translations.plannedPlaceDelete),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
