import '../data/visited_countries_repository.dart';
import '../data/visited_country_model.dart';

enum VisitedCountriesStatus { initial, loading, success, failure }

class VisitedCountriesState {
  static const Object _unset = Object();

  final VisitedCountriesStatus status;
  final List<VisitedCountryModel> visitedCountries;
  final bool isUpdatingVisitedCountry;
  final VisitedCountriesFailureType? failureType;

  const VisitedCountriesState({
    required this.status,
    required this.visitedCountries,
    required this.isUpdatingVisitedCountry,
    required this.failureType,
  });

  const VisitedCountriesState.initial()
    : status = VisitedCountriesStatus.initial,
      visitedCountries = const [],
      isUpdatingVisitedCountry = false,
      failureType = null;

  Set<String> get visitedCountryIds {
    return visitedCountries.map((country) => country.id).toSet();
  }

  VisitedCountriesState copyWith({
    VisitedCountriesStatus? status,
    List<VisitedCountryModel>? visitedCountries,
    bool? isUpdatingVisitedCountry,
    Object? failureType = _unset,
  }) {
    return VisitedCountriesState(
      status: status ?? this.status,
      visitedCountries: visitedCountries ?? this.visitedCountries,
      isUpdatingVisitedCountry:
          isUpdatingVisitedCountry ?? this.isUpdatingVisitedCountry,
      failureType: failureType == _unset
          ? this.failureType
          : failureType as VisitedCountriesFailureType?,
    );
  }
}
