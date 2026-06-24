import 'package:cloud_firestore/cloud_firestore.dart';

import 'trip_diary_entry.dart';

class TripDiaryEntryMapper {
  const TripDiaryEntryMapper._();

  static const titleField = 'title';
  static const descriptionField = 'description';
  static const countryCodeField = 'countryCode';
  static const countryNameField = 'countryName';
  static const countryFlagUrlField = 'countryFlagUrl';
  static const coverPhotoFileNameField = 'coverPhotoFileName';
  static const photosCountField = 'photosCount';
  static const travelDateField = 'travelDate';
  static const createdAtField = 'createdAt';
  static const updatedAtField = 'updatedAt';

  static TripDiaryEntry fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return TripDiaryEntry(
      id: id,
      title: data[titleField]?.toString(),
      description: data[descriptionField]?.toString(),
      countryCode: data[countryCodeField]?.toString(),
      countryName: data[countryNameField]?.toString(),
      countryFlagUrl: data[countryFlagUrlField]?.toString(),
      coverPhotoFileName: data[coverPhotoFileNameField]?.toString(),
      photosCount: _readInt(data[photosCountField]),
      travelDate: _readDate(data[travelDateField]),
      createdAt: _readDate(data[createdAtField]),
      updatedAt: _readDate(data[updatedAtField]),
    );
  }

  static Map<String, dynamic> toCreateFirestore(TripDiaryEntry entry) {
    return {
      titleField: entry.title,
      descriptionField: entry.description,
      countryCodeField: entry.countryCode,
      countryNameField: entry.countryName,
      countryFlagUrlField: entry.countryFlagUrl,
      coverPhotoFileNameField: entry.coverPhotoFileName,
      photosCountField: entry.photosCount,
      travelDateField: entry.travelDate == null
          ? null
          : Timestamp.fromDate(entry.travelDate!),
      createdAtField: FieldValue.serverTimestamp(),
      updatedAtField: FieldValue.serverTimestamp(),
    };
  }

  static DateTime? _readDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
}
