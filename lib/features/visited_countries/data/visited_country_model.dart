import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../countries/data/country_model.dart';

part 'visited_country_model.freezed.dart';

@freezed
abstract class VisitedCountryModel with _$VisitedCountryModel {
  static const nameField = 'name';
  static const flagUrlField = 'flagUrl';
  static const latitudeField = 'latitude';
  static const longitudeField = 'longitude';
  static const visitedAtField = 'visitedAt';

  const VisitedCountryModel._();

  const factory VisitedCountryModel({
    required String id,
    required String? name,
    required String? flagUrl,
    required double? latitude,
    required double? longitude,
    required DateTime? visitedAt,
  }) = _VisitedCountryModel;

  factory VisitedCountryModel.fromCountry({
    required String id,
    required CountryModel country,
  }) {
    return VisitedCountryModel(
      id: id,
      name: country.name,
      flagUrl: country.flagUrl,
      latitude: country.latitude,
      longitude: country.longitude,
      visitedAt: null,
    );
  }

  factory VisitedCountryModel.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return VisitedCountryModel(
      id: id,
      name: data[nameField]?.toString(),
      flagUrl: data[flagUrlField]?.toString(),
      latitude: _readDouble(data[latitudeField]),
      longitude: _readDouble(data[longitudeField]),
      visitedAt: _readDate(data[visitedAtField]),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      nameField: name,
      flagUrlField: flagUrl,
      latitudeField: latitude,
      longitudeField: longitude,
      visitedAtField: FieldValue.serverTimestamp(),
    };
  }

  static double? _readDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '');
  }

  static DateTime? _readDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return null;
  }
}
