import '../../visited_countries/data/visited_country_model.dart';
import '../data/device_location_service.dart';

enum MapDisplayMode { globe, flat }

class MapState {
  static const Object _unset = Object();

  final bool isLoadingLocation;
  final bool isLoadingVisitedCountries;
  final DeviceLocation? currentLocation;
  final List<VisitedCountryModel> visitedCountries;
  final bool isCurrentLocationCardVisible;
  final DeviceLocationFailureType? locationErrorType;
  final int focusRequestId;
  final MapDisplayMode mapDisplayMode;

  const MapState({
    required this.isLoadingLocation,
    required this.isLoadingVisitedCountries,
    required this.currentLocation,
    required this.visitedCountries,
    required this.isCurrentLocationCardVisible,
    required this.locationErrorType,
    required this.focusRequestId,
    required this.mapDisplayMode,
  });

  const MapState.initial()
    : isLoadingLocation = false,
      isLoadingVisitedCountries = true,
      currentLocation = null,
      visitedCountries = const [],
      isCurrentLocationCardVisible = false,
      locationErrorType = null,
      focusRequestId = 0,
      mapDisplayMode = MapDisplayMode.globe;

  MapState copyWith({
    bool? isLoadingLocation,
    bool? isLoadingVisitedCountries,
    Object? currentLocation = _unset,
    List<VisitedCountryModel>? visitedCountries,
    bool? isCurrentLocationCardVisible,
    Object? locationErrorType = _unset,
    int? focusRequestId,
    MapDisplayMode? mapDisplayMode,
  }) {
    return MapState(
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      isLoadingVisitedCountries:
          isLoadingVisitedCountries ?? this.isLoadingVisitedCountries,
      currentLocation: currentLocation == _unset
          ? this.currentLocation
          : currentLocation as DeviceLocation?,
      visitedCountries: visitedCountries ?? this.visitedCountries,
      isCurrentLocationCardVisible:
          isCurrentLocationCardVisible ?? this.isCurrentLocationCardVisible,
      locationErrorType: locationErrorType == _unset
          ? this.locationErrorType
          : locationErrorType as DeviceLocationFailureType?,
      focusRequestId: focusRequestId ?? this.focusRequestId,
      mapDisplayMode: mapDisplayMode ?? this.mapDisplayMode,
    );
  }
}
