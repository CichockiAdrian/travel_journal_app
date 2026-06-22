import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../countries/data/countries_repository.dart';
import '../../countries/data/country_model.dart';
import '../../countries/logic/countries_cubit.dart';
import '../../countries/logic/countries_state.dart';
import '../../countries/presentation/country_display_mapper.dart';
import '../../visited_countries/data/visited_countries_repository.dart';
import '../logic/trip_diary_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/trip_diary_repository.dart';

class TripDiaryFormPage extends StatefulWidget {
  final CountriesRepository countriesRepository;
  final VisitedCountriesRepository visitedCountriesRepository;

  const TripDiaryFormPage({
    super.key,
    required this.countriesRepository,
    required this.visitedCountriesRepository,
  });

  @override
  State<TripDiaryFormPage> createState() => _TripDiaryFormPageState();
}

class _TripDiaryFormPageState extends State<TripDiaryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _countryController = TextEditingController();

  CountryModel? _selectedCountry;
  DateTime _travelDate = DateTime.now();
  bool _markCountryAsVisited = true;
  bool _isSaving = false;

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
          CountriesCubit(countriesRepository: widget.countriesRepository)
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
      );

      if (_markCountryAsVisited) {
        await widget.visitedCountriesRepository.markAsVisited(selectedCountry);
      }

      if (!mounted) return;

      navigator.pop();
    } on TripDiaryException catch (error) {
      debugPrint('Trip diary save failed: ${error.type}');

      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(content: Text('Nie udało się zapisać wpisu: ${error.type}')),
      );
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
                        separatorBuilder: (_, _) {
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
