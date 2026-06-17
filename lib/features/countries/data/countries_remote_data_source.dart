import 'countries_api_service.dart';
import 'country_model.dart';

class CountriesRemoteDataSource {
  final CountriesApiService countriesApiService;

  CountriesRemoteDataSource({required this.countriesApiService});

  Future<List<CountryModel>> getAllCountries() {
    return countriesApiService.getAllCountries();
  }

  Future<List<CountryModel>> searchCountries(String query) {
    return countriesApiService.searchCountries(query);
  }
}
