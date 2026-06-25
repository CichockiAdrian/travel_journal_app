import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/visited_countries_repository.dart';
import '../data/visited_country_model.dart';

part 'visited_countries_state.freezed.dart';

enum VisitedCountriesStatus { initial, loading, success, failure }

@freezed
abstract class VisitedCountriesState with _$VisitedCountriesState {
  const VisitedCountriesState._();

  const factory VisitedCountriesState({
    required VisitedCountriesStatus status,
    @Default([]) List<VisitedCountryModel> visitedCountries,
    @Default(false) bool isUpdatingVisitedCountry,
    VisitedCountriesFailureType? failureType,
  }) = _VisitedCountriesState;

  const factory VisitedCountriesState.initial({
    @Default(VisitedCountriesStatus.initial) VisitedCountriesStatus status,
    @Default([]) List<VisitedCountryModel> visitedCountries,
    @Default(false) bool isUpdatingVisitedCountry,
    VisitedCountriesFailureType? failureType,
  }) = _InitialVisitedCountriesState;

  Set<String> get visitedCountryIds {
    return visitedCountries.map((country) => country.id).toSet();
  }

  int get visitedCountriesWithCoordinatesCount {
    return visitedCountries.where((country) {
      return country.latitude != null && country.longitude != null;
    }).length;
  }
}
