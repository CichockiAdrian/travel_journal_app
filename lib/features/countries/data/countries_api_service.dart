import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'country_model.dart';

class CountriesApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.restcountries.com/countries/v5',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Options _authOptions() {
    final token = dotenv.env['REST_COUNTRIES_TOKEN'];

    if (token == null || token.isEmpty) {
      throw Exception('Brak REST_COUNTRIES_TOKEN w pliku .env');
    }

    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<List<CountryModel>> getAllCountries() async {
    final response = await _dio.get('', options: _authOptions());

    return _parseCountries(response.data);
  }

  Future<List<CountryModel>> searchCountries(String query) async {
    final response = await _dio.get(
      '',
      queryParameters: {'q': query},
      options: _authOptions(),
    );

    return _parseCountries(response.data);
  }

  List<CountryModel> _parseCountries(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(CountryModel.fromJson)
          .toList();
    }

    if (data is Map<String, dynamic>) {
      final results = data['data'] ?? data['countries'] ?? data['results'];

      if (results is List) {
        return results
            .whereType<Map<String, dynamic>>()
            .map(CountryModel.fromJson)
            .toList();
      }
    }

    return [];
  }
}
