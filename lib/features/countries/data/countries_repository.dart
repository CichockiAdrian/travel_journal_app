import 'countries_remote_data_source.dart';
import 'country_model.dart';

class CountriesRepository {
  final CountriesRemoteDataSource remoteDataSource;

  CountriesRepository({required this.remoteDataSource});

  Future<List<CountryModel>> getAllCountries() {
    return remoteDataSource.getAllCountries();
  }

  Future<List<CountryModel>> searchCountries(String query) {
    return remoteDataSource.searchCountries(query);
  }
}
