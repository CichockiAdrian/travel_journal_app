import 'package:cloud_firestore/cloud_firestore.dart';

class VisitedCountryModel {
  final String id;
  final String name;
  final String? flagUrl;
  final double? latitude;
  final double? longitude;
  final DateTime? visitedAt;

  const VisitedCountryModel({
    required this.id,
    required this.name,
    required this.flagUrl,
    required this.latitude,
    required this.longitude,
    required this.visitedAt,
  });

  factory VisitedCountryModel.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return VisitedCountryModel(
      id: id,
      name: data['name']?.toString() ?? id,
      flagUrl: data['flagUrl']?.toString(),
      latitude: _readDouble(data['latitude']),
      longitude: _readDouble(data['longitude']),
      visitedAt: _readDate(data['visitedAt']),
    );
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
