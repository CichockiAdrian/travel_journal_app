import '../../countries/data/country_model.dart';

class VisitedCountryId {
  const VisitedCountryId._();

  static String? fromCountry(CountryModel country) {
    final code = country.code?.trim().toUpperCase();

    if (code != null && code.isNotEmpty) {
      return code;
    }

    final name = country.name.trim().toLowerCase();

    if (name.isEmpty) {
      return null;
    }

    return name.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }
}
