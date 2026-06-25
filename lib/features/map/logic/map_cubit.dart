import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../visited_countries/data/visited_countries_repository.dart';
import '../../visited_countries/data/visited_country_model.dart';
import '../data/device_location_service.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final DeviceLocationService _locationService;
  final VisitedCountriesRepository _visitedCountriesRepository;

  StreamSubscription<List<VisitedCountryModel>>? _visitedCountriesSubscription;

  MapCubit(this._locationService, this._visitedCountriesRepository)
    : super(const MapState.initial()) {
    _watchVisitedCountries();
  }

  Future<void> loadInitialLocation() async {
    await _loadCurrentLocation(showCardAfterLoad: false, focusAfterLoad: false);
  }

  Future<void> refreshCurrentLocation() async {
    await _loadCurrentLocation(showCardAfterLoad: true, focusAfterLoad: true);
  }

  void setMapDisplayMode(MapDisplayMode mode) {
    if (state.mapDisplayMode == mode) return;

    emit(
      state.copyWith(mapDisplayMode: mode, isCurrentLocationCardVisible: false),
    );
  }

  void hideCurrentLocationCard() {
    if (!state.isCurrentLocationCardVisible) return;
    emit(state.copyWith(isCurrentLocationCardVisible: false));
  }

  void clearLocationError() {
    if (state.locationErrorType == null) return;
    emit(state.copyWith(locationErrorType: null));
  }

  void _watchVisitedCountries() {
    _visitedCountriesSubscription = _visitedCountriesRepository
        .watchVisitedCountries()
        .listen(
          (visitedCountries) {
            emit(
              state.copyWith(
                isLoadingVisitedCountries: false,
                visitedCountries: visitedCountries,
              ),
            );
          },
          onError: (_) {
            emit(
              state.copyWith(
                isLoadingVisitedCountries: false,
                visitedCountries: const [],
              ),
            );
          },
        );
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

  @override
  Future<void> close() async {
    await _visitedCountriesSubscription?.cancel();
    return super.close();
  }
}
