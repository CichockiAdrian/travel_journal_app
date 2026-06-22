import '../../countries/data/country_model.dart';
import 'visited_country_model.dart';

enum VisitedCountriesFailureType { notAuthenticated, missingCountryId, unknown }

class VisitedCountriesException implements Exception {
  final VisitedCountriesFailureType type;

  const VisitedCountriesException(this.type);
}

abstract class VisitedCountriesRepository {
  Stream<List<VisitedCountryModel>> watchVisitedCountries();

  Future<void> markAsVisited(CountryModel country);

  Future<void> removeFromVisited(CountryModel country);
}
