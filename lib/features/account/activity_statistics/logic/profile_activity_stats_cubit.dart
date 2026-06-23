import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../trip_diary/data/trip_diary_entry.dart';
import '../../../trip_diary/data/trip_diary_repository.dart';
import '../../../visited_countries/data/visited_countries_repository.dart';
import '../../../visited_countries/data/visited_country_model.dart';
import 'profile_activity_stats_calculator.dart';
import 'profile_activity_stats_state.dart';

class ProfileActivityStatsCubit extends Cubit<ProfileActivityStatsState> {
  final TripDiaryRepository _tripDiaryRepository;
  final VisitedCountriesRepository _visitedCountriesRepository;
  final ProfileActivityStatsCalculator _calculator;

  StreamSubscription<List<TripDiaryEntry>>? _entriesSubscription;
  StreamSubscription<List<VisitedCountryModel>>? _visitedCountriesSubscription;

  List<TripDiaryEntry>? _entries;
  List<VisitedCountryModel>? _visitedCountries;

  ProfileActivityStatsCubit(
    this._tripDiaryRepository,
    this._visitedCountriesRepository,
    this._calculator,
  ) : super(const ProfileActivityStatsState());

  void watchStats() {
    emit(
      state.copyWith(
        status: ProfileActivityStatsStatus.loading,
        errorMessage: null,
      ),
    );

    _entriesSubscription?.cancel();
    _visitedCountriesSubscription?.cancel();

    _entriesSubscription = _tripDiaryRepository.watchEntries().listen((
      entries,
    ) {
      _entries = entries;
      _emitStatsIfReady();
    }, onError: _emitFailure);

    _visitedCountriesSubscription = _visitedCountriesRepository
        .watchVisitedCountries()
        .listen((visitedCountries) {
          _visitedCountries = visitedCountries;
          _emitStatsIfReady();
        }, onError: _emitFailure);
  }

  void _emitStatsIfReady() {
    final entries = _entries;
    final visitedCountries = _visitedCountries;

    if (entries == null || visitedCountries == null) return;

    final stats = _calculator.calculate(
      entries: entries,
      visitedCountries: visitedCountries,
    );

    emit(
      state.copyWith(
        status: ProfileActivityStatsStatus.success,
        stats: stats,
        errorMessage: null,
      ),
    );
  }

  void _emitFailure(Object error) {
    emit(
      state.copyWith(
        status: ProfileActivityStatsStatus.failure,
        errorMessage: error.toString(),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _entriesSubscription?.cancel();
    await _visitedCountriesSubscription?.cancel();

    return super.close();
  }
}
