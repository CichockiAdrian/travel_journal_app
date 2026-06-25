import 'planned_place_model.dart';

class NearbyPlannedPlaceResult {
  final PlannedPlaceModel place;
  final double distanceInMeters;

  const NearbyPlannedPlaceResult({
    required this.place,
    required this.distanceInMeters,
  });
}
