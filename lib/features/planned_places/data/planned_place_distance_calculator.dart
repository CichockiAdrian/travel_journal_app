import 'package:geolocator/geolocator.dart';

import '../../map/data/device_location_service.dart';
import 'planned_place_model.dart';

class PlannedPlaceDistanceCalculator {
  const PlannedPlaceDistanceCalculator();

  double calculateDistanceInMeters({
    required DeviceLocation currentLocation,
    required PlannedPlaceModel plannedPlace,
  }) {
    return Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      plannedPlace.latitude,
      plannedPlace.longitude,
    );
  }
}
