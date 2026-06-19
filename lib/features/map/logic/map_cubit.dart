import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/device_location_service.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final DeviceLocationService _locationService;

  MapCubit(this._locationService) : super(const MapState.initial());

  Future<void> loadInitialLocation() async {
    await _loadCurrentLocation(showCardAfterLoad: false, focusAfterLoad: false);
  }

  Future<void> refreshCurrentLocation() async {
    await _loadCurrentLocation(showCardAfterLoad: true, focusAfterLoad: true);
  }

  void hideCurrentLocationCard() {
    if (!state.isCurrentLocationCardVisible) return;

    emit(state.copyWith(isCurrentLocationCardVisible: false));
  }

  void clearLocationError() {
    if (state.locationErrorType == null) return;

    emit(state.copyWith(locationErrorType: null));
  }

  Future<void> _loadCurrentLocation({
    required bool showCardAfterLoad,
    required bool focusAfterLoad,
  }) async {
    if (state.isLoadingLocation) return;

    emit(state.copyWith(isLoadingLocation: true, locationErrorType: null));

    try {
      final location = await _locationService.getCurrentLocation();

      emit(
        state.copyWith(
          isLoadingLocation: false,
          currentLocation: location,
          isCurrentLocationCardVisible: showCardAfterLoad,
          focusRequestId: focusAfterLoad
              ? state.focusRequestId + 1
              : state.focusRequestId,
        ),
      );
    } on DeviceLocationException catch (error) {
      emit(
        state.copyWith(
          isLoadingLocation: false,
          isCurrentLocationCardVisible: false,
          locationErrorType: error.type,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoadingLocation: false,
          isCurrentLocationCardVisible: false,
          locationErrorType: DeviceLocationFailureType.unknown,
        ),
      );
    }
  }
}
