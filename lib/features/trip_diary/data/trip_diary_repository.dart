import '../../countries/data/country_model.dart';
import 'trip_diary_entry.dart';

enum TripDiaryFailureType { notAuthenticated, missingCountryCode, unknown }

class TripDiaryException implements Exception {
  final TripDiaryFailureType type;

  const TripDiaryException(this.type);
}

abstract class TripDiaryRepository {
  Stream<List<TripDiaryEntry>> watchEntries();

  Future<void> addEntry({
    required String title,
    required String description,
    required CountryModel country,
    required DateTime travelDate,
  });

  Future<void> deleteEntry(String entryId);
}
