import '../../map/data/device_location_service.dart';
import 'nearby_planned_place_result.dart';
import 'planned_place_distance_calculator.dart';
import 'planned_place_model.dart';
import 'planned_places_repository.dart';

class PlannedPlacesNearbyChecker {
  static const double nearbyDistanceThresholdInMeters = 1000;

  final DeviceLocationService _locationService;
  final PlannedPlacesRepository _plannedPlacesRepository;
  final PlannedPlaceDistanceCalculator _distanceCalculator;

  String? _lastNotifiedPlaceId;

  PlannedPlacesNearbyChecker(
    this._locationService,
    this._plannedPlacesRepository,
    this._distanceCalculator,
  );

  Future<NearbyPlannedPlaceResult?> checkNearestNearbyPlace() async {
    try {
      final currentLocation = await _locationService.getCurrentLocation();
      final places = await _plannedPlacesRepository.watchPlannedPlaces().first;

      final openPlaces = places.where((place) {
        return !place.isCompleted;
      });

      PlannedPlaceModel? nearestPlace;
      double? nearestDistance;

      for (final place in openPlaces) {
        final distance = _distanceCalculator.calculateDistanceInMeters(
          currentLocation: currentLocation,
          plannedPlace: place,
        );

        if (nearestDistance == null || distance < nearestDistance) {
          nearestPlace = place;
          nearestDistance = distance;
        }
      }

      if (nearestPlace == null || nearestDistance == null) {
        _lastNotifiedPlaceId = null;
        return null;
      }

      final isNearby = nearestDistance <= nearbyDistanceThresholdInMeters;

      if (!isNearby) {
        _lastNotifiedPlaceId = null;
        return null;
      }

      if (_lastNotifiedPlaceId == nearestPlace.id) {
        return null;
      }

      _lastNotifiedPlaceId = nearestPlace.id;

      return NearbyPlannedPlaceResult(
        place: nearestPlace,
        distanceInMeters: nearestDistance,
      );
    } catch (_) {
      return null;
    }
  }
}
