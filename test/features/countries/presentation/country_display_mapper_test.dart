import 'package:flutter_test/flutter_test.dart';
import 'package:travel_journal_app/features/countries/data/country_model.dart';
import 'package:travel_journal_app/features/countries/presentation/country_display_mapper.dart';
import 'package:travel_journal_app/l10n/generated/app_localizations_en.dart';
import 'package:travel_journal_app/l10n/generated/app_localizations_pl.dart';

void main() {
  final translationsEn = AppLocalizationsEn();
  final translationsPl = AppLocalizationsPl();

  group('CountryDisplayMapper', () {
    test('maps valid country with all fields for English locale', () {
      const country = CountryModel(
        code: 'DEU',
        name: 'Germany',
        translatedNames: {'pol': 'Niemcy', 'deu': 'Deutschland'},
        capital: 'Berlin',
        flagUrl: 'https://flagcdn.com/w320/de.png',
        region: 'Europe',
        subregion: 'Western Europe',
        population: 83240525,
        latitude: 51.0,
        longitude: 9.0,
      );

      final displayData = CountryDisplayMapper.fromCountry(
        country: country,
        languageCode: 'en',
        translations: translationsEn,
      );

      expect(displayData.name, equals('Germany'));
      expect(displayData.capital, equals('Berlin'));
      expect(displayData.region, equals('Europe'));
    });

    test('maps valid country with translation for Polish locale', () {
      const country = CountryModel(
        code: 'DEU',
        name: 'Germany',
        translatedNames: {'pol': 'Niemcy', 'deu': 'Deutschland'},
        capital: 'Berlin',
        flagUrl: 'https://flagcdn.com/w320/de.png',
        region: 'Europe',
        subregion: 'Western Europe',
        population: 83240525,
        latitude: 51.0,
        longitude: 9.0,
      );

      final displayData = CountryDisplayMapper.fromCountry(
        country: country,
        languageCode: 'pl',
        translations: translationsPl,
      );

      expect(displayData.name, equals('Niemcy'));
      expect(displayData.capital, equals('Berlin'));
      expect(displayData.region, equals('Europa'));
    });

    test('uses subregion for Americas region', () {
      const country = CountryModel(
        code: 'CAN',
        name: 'Canada',
        translatedNames: {'pol': 'Kanada'},
        capital: 'Ottawa',
        flagUrl: 'https://flagcdn.com/w320/ca.png',
        region: 'Americas',
        subregion: 'North America',
        population: 38005238,
        latitude: 60.0,
        longitude: -95.0,
      );

      final displayDataEn = CountryDisplayMapper.fromCountry(
        country: country,
        languageCode: 'en',
        translations: translationsEn,
      );

      expect(displayDataEn.region, equals('North America'));

      final displayDataPl = CountryDisplayMapper.fromCountry(
        country: country,
        languageCode: 'pl',
        translations: translationsPl,
      );

      expect(displayDataPl.region, equals('Ameryka Północna'));
    });

    test('uses localized fallbacks for missing properties', () {
      const country = CountryModel(
        code: 'UNKNOWN',
        name: null,
        translatedNames: {},
        capital: null,
        flagUrl: null,
        region: null,
        subregion: null,
        population: null,
        latitude: null,
        longitude: null,
      );

      final displayDataEn = CountryDisplayMapper.fromCountry(
        country: country,
        languageCode: 'en',
        translations: translationsEn,
      );

      expect(displayDataEn.name, equals(translationsEn.unknownCountry));
      expect(displayDataEn.capital, equals(translationsEn.noData));
      expect(displayDataEn.region, equals(translationsEn.noData));

      final displayDataPl = CountryDisplayMapper.fromCountry(
        country: country,
        languageCode: 'pl',
        translations: translationsPl,
      );

      expect(displayDataPl.name, equals(translationsPl.unknownCountry));
      expect(displayDataPl.capital, equals(translationsPl.noData));
      expect(displayDataPl.region, equals(translationsPl.noData));
    });
  });
}
