import 'planned_place_model.dart';

enum PlannedPlacesFailureType {
  notAuthenticated,
  invalidTitle,
  invalidCoordinates,
  unknown,
}

class PlannedPlacesException implements Exception {
  final PlannedPlacesFailureType type;

  const PlannedPlacesException(this.type);
}

abstract class PlannedPlacesRepository {
  Stream<List<PlannedPlaceModel>> watchPlannedPlaces();

  Future<void> addPlannedPlace({
    required String title,
    required String? note,
    required PlannedPlaceActionTag actionTag,
    required double latitude,
    required double longitude,
  });

  Future<void> removePlannedPlace(String placeId);

  Future<void> markAsCompleted(String placeId);

  Future<void> markAsOpen(String placeId);
}
