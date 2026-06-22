import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../countries/data/country_model.dart';
import '../data/visited_countries_repository.dart';
import '../data/visited_country_id.dart';
import 'visited_countries_state.dart';

class VisitedCountriesCubit extends Cubit<VisitedCountriesState> {
  final VisitedCountriesRepository _repository;

  StreamSubscription? _subscription;

  VisitedCountriesCubit(this._repository)
    : super(const VisitedCountriesState.initial());

  void watchVisitedCountries() {
    emit(
      state.copyWith(status: VisitedCountriesStatus.loading, failureType: null),
    );

    _subscription?.cancel();
    _subscription = _repository.watchVisitedCountries().listen(
      (visitedCountries) {
        emit(
          state.copyWith(
            status: VisitedCountriesStatus.success,
            visitedCountries: visitedCountries,
            failureType: null,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: VisitedCountriesStatus.failure,
            failureType: error is VisitedCountriesException
                ? error.type
                : VisitedCountriesFailureType.unknown,
          ),
        );
      },
    );
  }

  Future<void> toggleVisitedCountry(CountryModel country) async {
    if (state.isUpdatingVisitedCountry) return;

    final countryId = VisitedCountryId.fromCountry(country);

    if (countryId == null) {
      emit(
        state.copyWith(
          failureType: VisitedCountriesFailureType.missingCountryId,
        ),
      );
      return;
    }

    emit(state.copyWith(isUpdatingVisitedCountry: true, failureType: null));

    try {
      final isVisited = state.visitedCountryIds.contains(countryId);

      if (isVisited) {
        await _repository.removeFromVisited(country);
      } else {
        await _repository.markAsVisited(country);
      }

      emit(state.copyWith(isUpdatingVisitedCountry: false, failureType: null));
    } on VisitedCountriesException catch (error) {
      emit(
        state.copyWith(
          isUpdatingVisitedCountry: false,
          failureType: error.type,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isUpdatingVisitedCountry: false,
          failureType: VisitedCountriesFailureType.unknown,
        ),
      );
    }
  }

  void clearFailure() {
    if (state.failureType == null) return;

    emit(state.copyWith(failureType: null));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
