import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/di/service_locator.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../countries/data/countries_repository.dart';
import '../../countries/data/country_model.dart';
import '../../countries/logic/countries_cubit.dart';
import '../../countries/logic/countries_state.dart';
import '../../countries/presentation/country_display_mapper.dart';
import '../../visited_countries/data/visited_countries_repository.dart';
import '../data/trip_diary_failure.dart';
import '../data/trip_diary_limits.dart';
import '../logic/trip_diary_cubit.dart';

class TripDiaryFormPage extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;

  const TripDiaryFormPage({
    super.key,
    this.initialTitle,
    this.initialDescription,
  });

  @override
  State<TripDiaryFormPage> createState() => _TripDiaryFormPageState();
}

class _TripDiaryFormPageState extends State<TripDiaryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _countryController = TextEditingController();
  final _imagePicker = ImagePicker();

  final List<File> _selectedPhotos = [];

  CountryModel? _selectedCountry;
  DateTime _travelDate = DateTime.now();
  bool _markCountryAsVisited = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final initialTitle = widget.initialTitle?.trim();
    final initialDescription = widget.initialDescription?.trim();

    if (initialTitle != null && initialTitle.isNotEmpty) {
      _titleController.text = initialTitle;
    }

    if (initialDescription != null && initialDescription.isNotEmpty) {
      _descriptionController.text = initialDescription;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CountriesCubit(countriesRepository: getIt<CountriesRepository>())
            ..loadAllCountries(),
      child: Builder(
        builder: (context) {
          final translations = AppLocalizations.of(context);
          final locale = Localizations.localeOf(context).toLanguageTag();

          return Scaffold(
            appBar: AppBar(
              title: Text(translations.addTripDiaryEntry),
              actions: [
                IconButton(
                  onPressed: _isSaving ? null : _saveEntry,
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
            body: BlocBuilder<CountriesCubit, CountriesState>(
              builder: (context, countriesState) {
                if (countriesState.status == CountriesStatus.loading &&
                    countriesState.allCountries.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (countriesState.status == CountriesStatus.failure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        translations.countriesFetchFailed,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: translations.entryTitle,
                          hintText: translations.entryTitleHint,
                          border: const OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return translations.titleRequired;
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _countryController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: translations.tripCountry,
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.keyboard_arrow_down),
                        ),
                        onTap: () {
                          _openCountryPicker(context.read<CountriesCubit>());
                        },
                        validator: (_) {
                          if (_selectedCountry == null) {
                            return translations.countryRequired;
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: ValueKey(_travelDate.toIso8601String()),
                        readOnly: true,
                        initialValue: DateFormat.yMMMd(
                          locale,
                        ).format(_travelDate),
                        decoration: InputDecoration(
                          labelText: translations.tripDate,
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: translations.description,
                          hintText: translations.descriptionHint,
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        minLines: 5,
                        maxLines: 8,
                      ),
                      const SizedBox(height: 16),
                      _TripDiaryPhotosPicker(
                        photos: _selectedPhotos,
                        isSaving: _isSaving,
                        onAddPhotos: _pickPhotos,
                        onRemovePhoto: _removePhoto,
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _markCountryAsVisited,
                        onChanged: (value) {
                          setState(() => _markCountryAsVisited = value);
                        },
                        title: Text(translations.markCountryAsVisitedWithEntry),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _isSaving ? null : _saveEntry,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check),
                        label: Text(translations.save),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openCountryPicker(CountriesCubit countriesCubit) async {
    FocusScope.of(context).unfocus();

    if (countriesCubit.state.allCountries.isNotEmpty) {
      countriesCubit.searchCountries('');
    }

    final pickedCountry = await showModalBottomSheet<CountryModel>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) {
        return BlocProvider.value(
          value: countriesCubit,
          child: const _TripDiaryCountryPickerSheet(),
        );
      },
    );

    if (pickedCountry == null) return;

    setState(() {
      _selectedCountry = pickedCountry;
      _countryController.text = _countryDisplayName(pickedCountry, context);
    });
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _travelDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) return;

    setState(() => _travelDate = pickedDate);
  }

  Future<void> _pickPhotos() async {
    final translations = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final remainingSlots =
        TripDiaryLimits.maxPhotosPerEntry - _selectedPhotos.length;

    if (remainingSlots <= 0) {
      messenger.showSnackBar(
        SnackBar(content: Text(translations.tripDiaryPhotosLimitReached)),
      );
      return;
    }

    final source = await showModalBottomSheet<_PhotoSource>(
      context: context,
      showDragHandle: true,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(translations.takePhoto),
                onTap: () {
                  Navigator.pop(bottomSheetContext, _PhotoSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(translations.chooseFromGallery),
                onTap: () {
                  Navigator.pop(bottomSheetContext, _PhotoSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    switch (source) {
      case _PhotoSource.camera:
        await _takePhoto();
        break;
      case _PhotoSource.gallery:
        await _pickPhotosFromGallery();
        break;
    }
  }

  Future<void> _takePhoto() async {
    final translations = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final remainingSlots =
        TripDiaryLimits.maxPhotosPerEntry - _selectedPhotos.length;

    if (remainingSlots <= 0) {
      messenger.showSnackBar(
        SnackBar(content: Text(translations.tripDiaryPhotosLimitReached)),
      );
      return;
    }

    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (pickedImage == null) return;

    setState(() {
      _selectedPhotos.add(File(pickedImage.path));
    });
  }

  Future<void> _pickPhotosFromGallery() async {
    final translations = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final remainingSlots =
        TripDiaryLimits.maxPhotosPerEntry - _selectedPhotos.length;

    if (remainingSlots <= 0) {
      messenger.showSnackBar(
        SnackBar(content: Text(translations.tripDiaryPhotosLimitReached)),
      );
      return;
    }

    final pickedImages = await _imagePicker.pickMultiImage(imageQuality: 85);

    if (pickedImages.isEmpty) return;

    final selectedImages = pickedImages.take(remainingSlots).map((image) {
      return File(image.path);
    }).toList();

    setState(() {
      _selectedPhotos.addAll(selectedImages);
    });

    if (pickedImages.length > remainingSlots) {
      messenger.showSnackBar(
        SnackBar(content: Text(translations.tripDiaryPhotosLimitReached)),
      );
    }
  }

  void _removePhoto(File photo) {
    setState(() {
      _selectedPhotos.remove(photo);
    });
  }

  Future<void> _saveEntry() async {
    final translations = AppLocalizations.of(context);
    final tripDiaryCubit = context.read<TripDiaryCubit>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (!_formKey.currentState!.validate()) return;

    final selectedCountry = _selectedCountry;

    if (selectedCountry == null) return;

    setState(() => _isSaving = true);

    try {
      await tripDiaryCubit.addEntry(
        title: _titleController.text,
        description: _descriptionController.text,
        country: selectedCountry,
        travelDate: _travelDate,
        photos: _selectedPhotos,
      );

      if (_markCountryAsVisited) {
        await getIt<VisitedCountriesRepository>().markAsVisited(
          selectedCountry,
        );
      }

      if (!mounted) return;

      navigator.pop();
    } on TripDiaryException catch (error) {
      debugPrint('Trip diary save failed: ${error.type}');

      if (!mounted) return;

      final message = switch (error.type) {
        TripDiaryFailureType.tooManyPhotos =>
          translations.tripDiaryPhotosLimitReached,
        _ => translations.tripDiarySaveFailed,
      };

      messenger.showSnackBar(SnackBar(content: Text(message)));
    } on FirebaseException catch (error, stackTrace) {
      debugPrint(
        'Trip diary Firebase save failed: ${error.code} ${error.message}\n$stackTrace',
      );

      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(content: Text('Firebase: ${error.code}')),
      );
    } catch (error, stackTrace) {
      debugPrint('Trip diary save failed: $error\n$stackTrace');

      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(content: Text(translations.tripDiarySaveFailed)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _countryDisplayName(CountryModel country, BuildContext context) {
    final translations = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return CountryDisplayMapper.fromCountry(
      country: country,
      languageCode: languageCode,
      translations: translations,
    ).name;
  }
}

class _TripDiaryPhotosPicker extends StatelessWidget {
  final List<File> photos;
  final bool isSaving;
  final VoidCallback onAddPhotos;
  final ValueChanged<File> onRemovePhoto;

  const _TripDiaryPhotosPicker({
    required this.photos,
    required this.isSaving,
    required this.onAddPhotos,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final canAddMorePhotos = photos.length < TripDiaryLimits.maxPhotosPerEntry;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translations.tripDiaryPhotos,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          translations.tripDiaryPhotosLimit(TripDiaryLimits.maxPhotosPerEntry),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        if (photos.isNotEmpty)
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              separatorBuilder: (context, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final photo = photos[index];

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        photo,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: isSaving ? null : () => onRemovePhoto(photo),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surface.withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        if (photos.isNotEmpty) const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: isSaving || !canAddMorePhotos ? null : onAddPhotos,
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: Text(translations.addPhotos),
        ),
      ],
    );
  }
}

class _TripDiaryCountryPickerSheet extends StatelessWidget {
  const _TripDiaryCountryPickerSheet();

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: translations.searchCountry,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  context.read<CountriesCubit>().searchCountries(value);
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<CountriesCubit, CountriesState>(
                  builder: (context, state) {
                    if (state.status == CountriesStatus.loading &&
                        state.visibleCountries.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == CountriesStatus.failure) {
                      return Center(
                        child: Text(
                          translations.countriesFetchFailed,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (state.visibleCountries.isEmpty) {
                      return Center(
                        child: Text(
                          state.allCountries.isEmpty
                              ? translations.noCountriesFound
                              : translations.noSearchResults,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.extentAfter < 200) {
                          context.read<CountriesCubit>().loadMore();
                        }

                        return false;
                      },
                      child: ListView.separated(
                        itemCount: state.visibleCountries.length,
                        separatorBuilder: (context, _) {
                          return const Divider(height: 1);
                        },
                        itemBuilder: (context, index) {
                          final country = state.visibleCountries[index];

                          final displayCountry =
                              CountryDisplayMapper.fromCountry(
                                country: country,
                                languageCode: languageCode,
                                translations: translations,
                              );

                          return ListTile(
                            title: Text(displayCountry.name),
                            subtitle: Text(displayCountry.region),
                            onTap: () {
                              Navigator.pop(context, country);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _PhotoSource { camera, gallery }
