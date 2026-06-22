import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_diary_photo.freezed.dart';

@freezed
abstract class TripDiaryPhoto with _$TripDiaryPhoto {
  static const entryIdField = 'entryId';
  static const countryCodeField = 'countryCode';
  static const urlField = 'url';
  static const storagePathField = 'storagePath';
  static const createdAtField = 'createdAt';

  const TripDiaryPhoto._();

  const factory TripDiaryPhoto({
    required String id,
    required String? entryId,
    required String? countryCode,
    required String? url,
    required String? storagePath,
    required DateTime? createdAt,
  }) = _TripDiaryPhoto;

  factory TripDiaryPhoto.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return TripDiaryPhoto(
      id: id,
      entryId: data[entryIdField]?.toString(),
      countryCode: data[countryCodeField]?.toString(),
      url: data[urlField]?.toString(),
      storagePath: data[storagePathField]?.toString(),
      createdAt: _readDate(data[createdAtField]),
    );
  }

  Map<String, dynamic> toCreateFirestore() {
    return {
      entryIdField: entryId,
      countryCodeField: countryCode,
      urlField: url,
      storagePathField: storagePath,
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
