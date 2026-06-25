import 'dart:io';

import '../../countries/data/country_model.dart';
import 'trip_diary_entry.dart';
import 'trip_diary_photo.dart';

abstract class TripDiaryRepository {
  Stream<List<TripDiaryEntry>> watchEntries();

  Stream<List<TripDiaryPhoto>> watchPhotosForEntry(String entryId);

  Future<void> addEntry({
    required String title,
    required String description,
    required CountryModel country,
    required DateTime travelDate,
    List<File> photos = const [],
  });

  Future<void> deleteEntry(String entryId);
}
