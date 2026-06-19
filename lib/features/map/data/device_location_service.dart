import 'package:geolocator/geolocator.dart';

class DeviceLocation {
  final double latitude;
  final double longitude;

  const DeviceLocation({required this.latitude, required this.longitude});
}

enum DeviceLocationFailureType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  unknown,
}

class DeviceLocationException implements Exception {
  final DeviceLocationFailureType type;

  const DeviceLocationException(this.type);
}

class DeviceLocationService {
  Future<DeviceLocation> getCurrentLocation() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      throw const DeviceLocationException(
        DeviceLocationFailureType.serviceDisabled,
      );
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const DeviceLocationException(
        DeviceLocationFailureType.permissionDenied,
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const DeviceLocationException(
        DeviceLocationFailureType.permissionDeniedForever,
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return DeviceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      throw const DeviceLocationException(DeviceLocationFailureType.unknown);
    }
  }
}
