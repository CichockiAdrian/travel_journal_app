import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/planned_place_model.dart';

class PlannedPlacesBackgroundTargetStorage {
  static const String targetsKey = 'planned_places_background_targets';

  Future<void> saveOpenPlaces({
    required List<PlannedPlaceModel> places,
    required String Function(PlannedPlaceModel place) titleBuilder,
    required String Function(PlannedPlaceModel place) bodyBuilder,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final encodedTargets = places.where((place) => !place.isCompleted).map((
      place,
    ) {
      return jsonEncode({
        'id': place.id,
        'title': titleBuilder(place),
        'body': bodyBuilder(place),
        'latitude': place.latitude,
        'longitude': place.longitude,
        'radiusMeters': 1000.0,
      });
    }).toList();

    await prefs.setStringList(targetsKey, encodedTargets);
  }
}
