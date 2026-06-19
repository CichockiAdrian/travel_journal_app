import '../data/device_location_service.dart';

class MapState {
  static const Object _unset = Object();

  final bool isLoadingLocation;
  final DeviceLocation? currentLocation;
  final bool isCurrentLocationCardVisible;
  final DeviceLocationFailureType? locationErrorType;
  final int focusRequestId;

  const MapState({
    required this.isLoadingLocation,
    required this.currentLocation,
    required this.isCurrentLocationCardVisible,
    required this.locationErrorType,
    required this.focusRequestId,
  });

  const MapState.initial()
    : isLoadingLocation = false,
      currentLocation = null,
      isCurrentLocationCardVisible = false,
      locationErrorType = null,
      focusRequestId = 0;

  MapState copyWith({
    bool? isLoadingLocation,
    Object? currentLocation = _unset,
    bool? isCurrentLocationCardVisible,
    Object? locationErrorType = _unset,
    int? focusRequestId,
  }) {
    return MapState(
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      currentLocation: currentLocation == _unset
          ? this.currentLocation
          : currentLocation as DeviceLocation?,
      isCurrentLocationCardVisible:
          isCurrentLocationCardVisible ?? this.isCurrentLocationCardVisible,
      locationErrorType: locationErrorType == _unset
          ? this.locationErrorType
          : locationErrorType as DeviceLocationFailureType?,
      focusRequestId: focusRequestId ?? this.focusRequestId,
    );
  }
}
