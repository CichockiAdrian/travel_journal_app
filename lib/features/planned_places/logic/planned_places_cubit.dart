import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../map/data/device_location_service.dart';
import '../data/planned_place_distance_calculator.dart';
import '../data/planned_place_model.dart';
import '../data/planned_places_repository.dart';
import 'planned_places_state.dart';

class PlannedPlacesCubit extends Cubit<PlannedPlacesState> {
  static const double nearbyDistanceThresholdInMeters = 1000;

  final PlannedPlacesRepository _repository;
  final PlannedPlaceDistanceCalculator _distanceCalculator;

  StreamSubscription<List<PlannedPlaceModel>>? _placesSubscription;
  DeviceLocation? _currentLocation;
  String? _lastNotifiedNearbyPlaceId;

  PlannedPlacesCubit(this._repository, this._distanceCalculator)
    : super(const PlannedPlacesState.initial()) {
    _watchPlannedPlaces();
  }

  Future<bool> addPlace({
    required String title,
    required String? note,
    required PlannedPlaceActionTag actionTag,
    required double latitude,
    required double longitude,
  }) async {
    emit(state.copyWith(isSaving: true, actionFailureType: null));

    try {
      await _repository.addPlannedPlace(
        title: title,
        note: note,
        actionTag: actionTag,
        latitude: latitude,
        longitude: longitude,
      );

      emit(state.copyWith(isSaving: false));
      return true;
    } catch (_) {
      emit(
        state.copyWith(
          isSaving: false,
          actionFailureType: PlannedPlacesFailureType.unknown,
        ),
      );
      return false;
    }
  }

  Future<void> removePlace(String placeId) async {
    try {
      await _repository.removePlannedPlace(placeId);
    } on PlannedPlacesException catch (error) {
      emit(state.copyWith(actionFailureType: error.type));
    } catch (_) {
      emit(state.copyWith(actionFailureType: PlannedPlacesFailureType.unknown));
    }
  }

  Future<void> togglePlaceCompletion(PlannedPlaceModel place) async {
    try {
      if (place.isCompleted) {
        await _repository.markAsOpen(place.id);
      } else {
        await _repository.markAsCompleted(place.id);
      }
    } on PlannedPlacesException catch (error) {
      emit(state.copyWith(actionFailureType: error.type));
    } catch (_) {
      emit(state.copyWith(actionFailureType: PlannedPlacesFailureType.unknown));
    }
  }

  void updateCurrentLocation(DeviceLocation location) {
    _currentLocation = location;
    _refreshDistances();
  }

  void clearPendingNearbyNotification() {
    if (state.pendingNearbyNotificationPlace == null &&
        state.pendingNearbyNotificationDistanceInMeters == null) {
      return;
    }

    emit(
      state.copyWith(
        pendingNearbyNotificationPlace: null,
        pendingNearbyNotificationDistanceInMeters: null,
      ),
    );
  }

  void clearFailure() {
    if (state.failureType == null && state.actionFailureType == null) {
      return;
    }

    emit(state.copyWith(failureType: null, actionFailureType: null));
  }

  void _watchPlannedPlaces() {
    _placesSubscription = _repository.watchPlannedPlaces().listen(
      (places) {
        emit(
          state.copyWith(isLoading: false, places: places, failureType: null),
        );

        _refreshDistances();
      },
      onError: (error) {
        final failureType = error is PlannedPlacesException
            ? error.type
            : PlannedPlacesFailureType.unknown;

        emit(
          state.copyWith(
            isLoading: false,
            places: const [],
            distanceByPlaceId: const {},
            nearestPlace: null,
            nearestPlaceDistanceInMeters: null,
            pendingNearbyNotificationPlace: null,
            pendingNearbyNotificationDistanceInMeters: null,
            failureType: failureType,
          ),
        );
      },
    );
  }

  void _refreshDistances() {
    final currentLocation = _currentLocation;

    if (currentLocation == null || state.places.isEmpty) {
      emit(
        state.copyWith(
          distanceByPlaceId: const {},
          nearestPlace: null,
          nearestPlaceDistanceInMeters: null,
          pendingNearbyNotificationPlace: null,
          pendingNearbyNotificationDistanceInMeters: null,
        ),
      );
      return;
    }

    final distanceByPlaceId = <String, double>{};

    for (final place in state.places) {
      distanceByPlaceId[place.id] = _distanceCalculator
          .calculateDistanceInMeters(
            currentLocation: currentLocation,
            plannedPlace: place,
          );
    }

    final openPlaces = state.places.where((place) => !place.isCompleted);

    PlannedPlaceModel? nearestPlace;
    double? nearestDistance;

    for (final place in openPlaces) {
      final distance = distanceByPlaceId[place.id];

      if (distance == null) {
        continue;
      }

      if (nearestDistance == null || distance < nearestDistance) {
        nearestPlace = place;
        nearestDistance = distance;
      }
    }

    PlannedPlaceModel? pendingNotificationPlace;
    double? pendingNotificationDistance;

    final isNearby =
        nearestPlace != null &&
        nearestDistance != null &&
        nearestDistance <= nearbyDistanceThresholdInMeters;

    if (isNearby && _lastNotifiedNearbyPlaceId != nearestPlace.id) {
      _lastNotifiedNearbyPlaceId = nearestPlace.id;
      pendingNotificationPlace = nearestPlace;
      pendingNotificationDistance = nearestDistance;
    }

    if (!isNearby) {
      _lastNotifiedNearbyPlaceId = null;
    }

    emit(
      state.copyWith(
        distanceByPlaceId: distanceByPlaceId,
        nearestPlace: nearestPlace,
        nearestPlaceDistanceInMeters: nearestDistance,
        pendingNearbyNotificationPlace: pendingNotificationPlace,
        pendingNearbyNotificationDistanceInMeters: pendingNotificationDistance,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _placesSubscription?.cancel();
    return super.close();
  }
}
