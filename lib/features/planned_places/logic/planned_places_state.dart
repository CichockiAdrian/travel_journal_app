import '../data/planned_place_model.dart';
import '../data/planned_places_repository.dart';

class PlannedPlacesState {
  static const Object _unset = Object();

  final bool isLoading;
  final bool isSaving;
  final List<PlannedPlaceModel> places;
  final Map<String, double> distanceByPlaceId;
  final PlannedPlaceModel? nearestPlace;
  final double? nearestPlaceDistanceInMeters;
  final PlannedPlaceModel? pendingNearbyNotificationPlace;
  final double? pendingNearbyNotificationDistanceInMeters;
  final PlannedPlacesFailureType? failureType;
  final PlannedPlacesFailureType? actionFailureType;

  const PlannedPlacesState({
    required this.isLoading,
    required this.isSaving,
    required this.places,
    required this.distanceByPlaceId,
    required this.nearestPlace,
    required this.nearestPlaceDistanceInMeters,
    required this.pendingNearbyNotificationPlace,
    required this.pendingNearbyNotificationDistanceInMeters,
    required this.failureType,
    required this.actionFailureType,
  });

  const PlannedPlacesState.initial()
    : isLoading = true,
      isSaving = false,
      places = const [],
      distanceByPlaceId = const {},
      nearestPlace = null,
      nearestPlaceDistanceInMeters = null,
      pendingNearbyNotificationPlace = null,
      pendingNearbyNotificationDistanceInMeters = null,
      failureType = null,
      actionFailureType = null;

  PlannedPlacesState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<PlannedPlaceModel>? places,
    Map<String, double>? distanceByPlaceId,
    Object? nearestPlace = _unset,
    Object? nearestPlaceDistanceInMeters = _unset,
    Object? pendingNearbyNotificationPlace = _unset,
    Object? pendingNearbyNotificationDistanceInMeters = _unset,
    Object? failureType = _unset,
    Object? actionFailureType = _unset,
  }) {
    return PlannedPlacesState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      places: places ?? this.places,
      distanceByPlaceId: distanceByPlaceId ?? this.distanceByPlaceId,
      nearestPlace: nearestPlace == _unset
          ? this.nearestPlace
          : nearestPlace as PlannedPlaceModel?,
      nearestPlaceDistanceInMeters: nearestPlaceDistanceInMeters == _unset
          ? this.nearestPlaceDistanceInMeters
          : nearestPlaceDistanceInMeters as double?,
      pendingNearbyNotificationPlace: pendingNearbyNotificationPlace == _unset
          ? this.pendingNearbyNotificationPlace
          : pendingNearbyNotificationPlace as PlannedPlaceModel?,
      pendingNearbyNotificationDistanceInMeters:
          pendingNearbyNotificationDistanceInMeters == _unset
          ? this.pendingNearbyNotificationDistanceInMeters
          : pendingNearbyNotificationDistanceInMeters as double?,
      failureType: failureType == _unset
          ? this.failureType
          : failureType as PlannedPlacesFailureType?,
      actionFailureType: actionFailureType == _unset
          ? this.actionFailureType
          : actionFailureType as PlannedPlacesFailureType?,
    );
  }
}
