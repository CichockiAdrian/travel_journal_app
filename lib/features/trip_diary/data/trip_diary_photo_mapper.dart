import 'package:cloud_firestore/cloud_firestore.dart';

import 'trip_diary_photo.dart';

class TripDiaryPhotoMapper {
  const TripDiaryPhotoMapper._();

  static const entryIdField = 'entryId';
  static const countryCodeField = 'countryCode';
  static const localFileNameField = 'localFileName';
  static const createdAtField = 'createdAt';

  static TripDiaryPhoto fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return TripDiaryPhoto(
      id: id,
      entryId: data[entryIdField]?.toString(),
      countryCode: data[countryCodeField]?.toString(),
      localFileName: data[localFileNameField]?.toString(),
      createdAt: _readDate(data[createdAtField]),
    );
  }

  static Map<String, dynamic> toCreateFirestore(TripDiaryPhoto photo) {
    return {
      entryIdField: photo.entryId,
      countryCodeField: photo.countryCode,
      localFileNameField: photo.localFileName,
      createdAtField: FieldValue.serverTimestamp(),
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
}
