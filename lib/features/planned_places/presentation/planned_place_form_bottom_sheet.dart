import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../logic/planned_places_cubit.dart';
import '../logic/planned_places_state.dart';

class PlannedPlaceFormBottomSheet extends StatefulWidget {
  final double latitude;
  final double longitude;

  const PlannedPlaceFormBottomSheet({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<PlannedPlaceFormBottomSheet> createState() {
    return _PlannedPlaceFormBottomSheetState();
  }
}

class _PlannedPlaceFormBottomSheetState
    extends State<PlannedPlaceFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await context.read<PlannedPlacesCubit>().addPlace(
      title: _titleController.text,
      note: _noteController.text,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: bottomInset + 16,
      ),
      child: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: BlocBuilder<PlannedPlacesCubit, PlannedPlacesState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translations.addPlannedPlace,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: translations.plannedPlaceTitle,
                      hintText: translations.plannedPlaceTitleHint,
                      prefixIcon: const Icon(Icons.place_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return translations.plannedPlaceTitleRequired;
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _noteController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: translations.plannedPlaceNote,
                      hintText: translations.plannedPlaceNoteHint,
                      prefixIcon: const Icon(Icons.notes_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${widget.latitude.toStringAsFixed(5)}, '
                          '${widget.longitude.toStringAsFixed(5)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: state.isSaving ? null : _submit,
                      icon: state.isSaving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(translations.savePlannedPlace),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
