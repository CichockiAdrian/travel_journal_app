import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_diary_entry.freezed.dart';

@freezed
abstract class TripDiaryEntry with _$TripDiaryEntry {
  static const titleField = 'title';
  static const descriptionField = 'description';
  static const countryCodeField = 'countryCode';
  static const countryNameField = 'countryName';
  static const countryFlagUrlField = 'countryFlagUrl';
  static const travelDateField = 'travelDate';
  static const createdAtField = 'createdAt';
  static const updatedAtField = 'updatedAt';

  const TripDiaryEntry._();

  const factory TripDiaryEntry({
    required String id,
    required String? title,
    required String? description,
    required String? countryCode,
    required String? countryName,
    required String? countryFlagUrl,
    required DateTime? travelDate,
    required DateTime? createdAt,
    required DateTime? updatedAt,
  }) = _TripDiaryEntry;

  factory TripDiaryEntry.fromFirestore({
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
      travelDate: _readDate(data[travelDateField]),
      createdAt: _readDate(data[createdAtField]),
      updatedAt: _readDate(data[updatedAtField]),
    );
  }

  Map<String, dynamic> toCreateFirestore() {
    return {
      titleField: title,
      descriptionField: description,
      countryCodeField: countryCode,
      countryNameField: countryName,
      countryFlagUrlField: countryFlagUrl,
      travelDateField: travelDate == null
          ? null
          : Timestamp.fromDate(travelDate!),
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
}
