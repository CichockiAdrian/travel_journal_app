import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../core/constants/app_urls.dart';
import 'country_model.dart';

class CountriesApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppUrls.restCountriesBaseUrl,
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
    const limit = 100;
    var offset = 0;
    var hasMore = true;

    final countries = <CountryModel>[];

    while (hasMore) {
      final response = await _dio.get(
        '',
        queryParameters: {'limit': limit, 'offset': offset},
        options: _authOptions(),
      );

      countries.addAll(_parseCountries(response.data));

      final meta = _readMeta(response.data);
      final more = meta?['more'];

      hasMore = more == true;
      offset += limit;
    }

    return countries;
  }

  Future<List<CountryModel>> searchCountries(String query) async {
    final response = await _dio.get(
      '',
      queryParameters: {'q': query, 'limit': 100},
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
      final responseData = data['data'];

      if (responseData is Map<String, dynamic>) {
        final objects = responseData['objects'];

        if (objects is List) {
          return objects
              .whereType<Map<String, dynamic>>()
              .map(CountryModel.fromJson)
              .toList();
        }
      }

      final results = data['countries'] ?? data['results'];

      if (results is List) {
        return results
            .whereType<Map<String, dynamic>>()
            .map(CountryModel.fromJson)
            .toList();
      }
    }

    return [];
  }

  Map<String, dynamic>? _readMeta(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    final responseData = data['data'];

    if (responseData is! Map<String, dynamic>) return null;

    final meta = responseData['meta'];

    if (meta is Map<String, dynamic>) {
      return meta;
    }

    return null;
  }
}
