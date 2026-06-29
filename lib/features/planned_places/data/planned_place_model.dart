import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'planned_place_model.freezed.dart';

enum PlannedPlaceActionTag {
  none('none'),
  photo('photo'),
  diary('diary');

  const PlannedPlaceActionTag(this.value);

  final String value;

  static PlannedPlaceActionTag fromValue(String? value) {
    return PlannedPlaceActionTag.values.firstWhere(
      (tag) => tag.value == value,
      orElse: () => PlannedPlaceActionTag.none,
    );
  }
}

@freezed
abstract class PlannedPlaceModel with _$PlannedPlaceModel {
  static const titleField = 'title';
  static const noteField = 'note';
  static const actionTagField = 'actionTag';
  static const latitudeField = 'latitude';
  static const longitudeField = 'longitude';
  static const isCompletedField = 'isCompleted';
  static const createdAtField = 'createdAt';
  static const completedAtField = 'completedAt';

  const PlannedPlaceModel._();

  const factory PlannedPlaceModel({
    required String id,
    required String title,
    required String? note,
    required PlannedPlaceActionTag actionTag,
    required double latitude,
    required double longitude,
    required bool isCompleted,
    required DateTime? createdAt,
    required DateTime? completedAt,
  }) = _PlannedPlaceModel;

  factory PlannedPlaceModel.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return PlannedPlaceModel(
      id: id,
      title: data[titleField]?.toString().trim() ?? '',
      note: _readNullableTrimmedString(data[noteField]),
      actionTag: PlannedPlaceActionTag.fromValue(
        data[actionTagField]?.toString(),
      ),
      latitude: _readDouble(data[latitudeField]) ?? 0,
      longitude: _readDouble(data[longitudeField]) ?? 0,
      isCompleted: data[isCompletedField] == true,
      createdAt: _readDate(data[createdAtField]),
      completedAt: _readDate(data[completedAtField]),
    );
  }

  Map<String, dynamic> toCreateFirestore() {
    return {
      titleField: title.trim(),
      noteField: _emptyToNull(note),
      actionTagField: actionTag.value,
      latitudeField: latitude,
      longitudeField: longitude,
      isCompletedField: false,
      createdAtField: FieldValue.serverTimestamp(),
    };
  }

  static String? _readNullableTrimmedString(dynamic value) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }

  static String? _emptyToNull(String? value) {
    final text = value?.trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }

  static double? _readDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '');
  }

  static DateTime? _readDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return null;
  }
}
