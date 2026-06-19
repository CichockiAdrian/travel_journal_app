import '../../../l10n/generated/app_localizations.dart';
import '../data/country_model.dart';

class CountryDisplayData {
  final String name;
  final String capital;
  final String region;

  const CountryDisplayData({
    required this.name,
    required this.capital,
    required this.region,
  });
}

class CountryDisplayMapper {
  static CountryDisplayData fromCountry({
    required CountryModel country,
    required String languageCode,
    required AppLocalizations translations,
  }) {
    return CountryDisplayData(
      name: _countryName(country, languageCode),
      capital: _capital(country, languageCode, translations),
      region: _region(country, languageCode),
    );
  }

  static String _countryName(CountryModel country, String languageCode) {
    if (languageCode == 'pl') {
      return country.translatedNames['pol'] ??
          country.translatedNames['pl'] ??
          country.name;
    }

    return country.name;
  }

  static String _capital(
    CountryModel country,
    String languageCode,
    AppLocalizations translations,
  ) {
    final capital = country.capital;

    if (capital == null || capital.isEmpty) {
      return translations.noData;
    }

    if (languageCode != 'pl') {
      return capital;
    }

    return _polishCapitalNames[capital] ?? capital;
  }

  static String _region(CountryModel country, String languageCode) {
    final rawRegion = _regionValueForDisplay(country);

    if (languageCode != 'pl') {
      return rawRegion;
    }

    return _polishRegions[rawRegion] ?? rawRegion;
  }

  static String _regionValueForDisplay(CountryModel country) {
    final subregion = country.subregion;

    if (country.region == 'Americas' &&
        subregion != null &&
        subregion.isNotEmpty) {
      return subregion;
    }

    return country.region;
  }

  static const Map<String, String> _polishRegions = {
    'Africa': 'Afryka',
    'Americas': 'Ameryka',
    'Asia': 'Azja',
    'Europe': 'Europa',
    'Oceania': 'Oceania',
    'Antarctic': 'Antarktyka',
    'Antarctica': 'Antarktyka',

    'Northern America': 'Ameryka Północna',
    'North America': 'Ameryka Północna',
    'South America': 'Ameryka Południowa',
    'Central America': 'Ameryka Środkowa',
    'Caribbean': 'Karaiby',
  };

  static const Map<String, String> _polishCapitalNames = {
    'Warsaw': 'Warszawa',
    'Prague': 'Praga',
    'Rome': 'Rzym',
    'Vienna': 'Wiedeń',
    'Paris': 'Paryż',
    'London': 'Londyn',
    'Copenhagen': 'Kopenhaga',
    'Lisbon': 'Lizbona',
    'Moscow': 'Moskwa',
    'Kyiv': 'Kijów',
    'Beijing': 'Pekin',
    'Tokyo': 'Tokio',
    'Athens': 'Ateny',
    'Brussels': 'Bruksela',
    'Bucharest': 'Bukareszt',
    'Budapest': 'Budapeszt',
    'Cairo': 'Kair',
    'Mexico City': 'Meksyk',
    'New Delhi': 'Nowe Delhi',
    'Seoul': 'Seul',
    'Stockholm': 'Sztokholm',
    'The Hague': 'Haga',
  };
}
