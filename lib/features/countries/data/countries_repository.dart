import 'countries_remote_data_source.dart';
import 'country_model.dart';

class CountriesRepository {
  final CountriesRemoteDataSource remoteDataSource;

  List<CountryModel>? _cachedCountries;

  CountriesRepository({required this.remoteDataSource});

  Future<List<CountryModel>> getAllCountries() async {
    final cachedCountries = _cachedCountries;

    if (cachedCountries != null) {
      return cachedCountries;
    }

    final countries = await remoteDataSource.getAllCountries();
    _cachedCountries = countries;

    return countries;
  }

  Future<List<CountryModel>> searchCountries(String query) {
    return remoteDataSource.searchCountries(query);
  }

  void clearCache() {
    _cachedCountries = null;
  }
}
