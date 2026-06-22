import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_model.freezed.dart';

@freezed
abstract class CountryModel with _$CountryModel {
  const CountryModel._();

  const factory CountryModel({
    required String name,
    required String? code,
    @Default({}) Map<String, String> translatedNames,
    required String? capital,
    required String? flagUrl,
    required String region,
    required String? subregion,
    required int? population,
    required double? latitude,
    required double? longitude,
  }) = _CountryModel;

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: _readName(json),
      code: _readCode(json),
      translatedNames: _readTranslatedNames(json),
      capital: _readCapital(json),
      flagUrl: _readFlag(json),
      region: _readRegion(json),
      subregion: _readSubregion(json),
      population: _readInt(json['population']),
      latitude: _readLatitude(json),
      longitude: _readLongitude(json),
    );
  }

  static String _readName(Map<String, dynamic> json) {
    final name = json['name'];

    if (name is String && name.trim().isNotEmpty) {
      return name;
    }

    if (name is Map) {
      return name['common']?.toString() ?? name['official']?.toString() ?? '';
    }

    final names = json['names'];

    if (names is Map) {
      return names['common']?.toString() ?? names['official']?.toString() ?? '';
    }

    return json['commonName']?.toString() ??
        json['officialName']?.toString() ??
        '';
  }

  static String? _readCode(Map<String, dynamic> json) {
    final value =
        json['cca2'] ??
        json['cca3'] ??
        json['iso2'] ??
        json['iso3'] ??
        json['code'];

    final code = value?.toString().trim().toUpperCase();

    if (code == null || code.isEmpty) {
      return null;
    }

    return code;
  }

  static Map<String, String> _readTranslatedNames(Map<String, dynamic> json) {
    final names = json['names'];
    final translationsFromNames = names is Map ? names['translations'] : null;

    final translations =
        translationsFromNames ??
        json['names.translations'] ??
        json['translations'];

    if (translations is! Map) {
      return {};
    }

    final result = <String, String>{};

    for (final entry in translations.entries) {
      final languageCode = entry.key.toString();
      final value = entry.value;

      if (value is Map) {
        final common = value['common']?.toString();

        if (common != null && common.isNotEmpty) {
          result[languageCode] = common;
        }
      } else if (value is String && value.isNotEmpty) {
        result[languageCode] = value;
      }
    }

    return result;
  }

  static String? _readCapital(Map<String, dynamic> json) {
    final capital = json['capital'];

    if (capital is String) {
      return capital;
    }

    if (capital is Map) {
      return capital['name']?.toString();
    }

    if (capital is List && capital.isNotEmpty) {
      final firstCapital = capital.first;

      if (firstCapital is String) {
        return firstCapital;
      }

      if (firstCapital is Map) {
        return firstCapital['name']?.toString();
      }

      return firstCapital.toString();
    }

    final capitals = json['capitals'];

    if (capitals is List && capitals.isNotEmpty) {
      final firstCapital = capitals.first;

      if (firstCapital is String) {
        return firstCapital;
      }

      if (firstCapital is Map) {
        return firstCapital['name']?.toString();
      }

      return firstCapital.toString();
    }

    return null;
  }

  static String? _readFlag(Map<String, dynamic> json) {
    final flags = json['flags'];

    if (flags is Map) {
      return flags['png']?.toString() ??
          flags['svg']?.toString() ??
          flags['url_png']?.toString() ??
          flags['url_svg']?.toString();
    }

    final flag = json['flag'];

    if (flag is Map) {
      return flag['png']?.toString() ??
          flag['svg']?.toString() ??
          flag['url_png']?.toString() ??
          flag['url_svg']?.toString();
    }

    final flagValue = flag?.toString();

    if (flagValue != null && flagValue.startsWith('http')) {
      return flagValue;
    }

    return null;
  }

  static String _readRegion(Map<String, dynamic> json) {
    final region = json['region'];

    if (region is String) {
      return region;
    }

    if (region is Map) {
      return region['name']?.toString() ?? '';
    }

    return '';
  }

  static String? _readSubregion(Map<String, dynamic> json) {
    final subregion = json['subregion'];

    if (subregion is String) {
      return subregion;
    }

    if (subregion is Map) {
      return subregion['name']?.toString();
    }

    final region = json['region'];

    if (region is Map) {
      return region['subregion']?.toString();
    }

    return null;
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '');
  }

  static double? _readLatitude(Map<String, dynamic> json) {
    final latlng = json['latlng'];

    if (latlng is List && latlng.isNotEmpty) {
      final value = latlng[0];

      if (value is num) return value.toDouble();
    }

    final coordinates = json['coordinates'];

    if (coordinates is Map) {
      final lat = coordinates['lat'] ?? coordinates['latitude'];

      if (lat is num) return lat.toDouble();
    }

    final geo = json['geo'];

    if (geo is Map) {
      final lat = geo['lat'] ?? geo['latitude'];

      if (lat is num) return lat.toDouble();
    }

    return null;
  }

  static double? _readLongitude(Map<String, dynamic> json) {
    final latlng = json['latlng'];

    if (latlng is List && latlng.length > 1) {
      final value = latlng[1];

      if (value is num) return value.toDouble();
    }

    final coordinates = json['coordinates'];

    if (coordinates is Map) {
      final lng =
          coordinates['lng'] ?? coordinates['lon'] ?? coordinates['longitude'];

      if (lng is num) return lng.toDouble();
    }

    final geo = json['geo'];

    if (geo is Map) {
      final lng = geo['lng'] ?? geo['lon'] ?? geo['longitude'];

      if (lng is num) return lng.toDouble();
    }

    return null;
  }
}
