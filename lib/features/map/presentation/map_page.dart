import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';

import '../../../core/constants/app_assets.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/device_location_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const String _currentLocationPointId = 'current-location';
  static const String _currentLocationGlowPointId = 'current-location-glow';

  late final FlutterEarthGlobeController _controller;
  final DeviceLocationService _locationService = DeviceLocationService();

  bool _isLoadingLocation = false;
  bool _hasCurrentLocationPoint = false;
  DeviceLocation? _currentLocation;

  @override
  void initState() {
    super.initState();

    _controller = FlutterEarthGlobeController(
      surface: const AssetImage(AppAssets.earthSurface),
      background: const AssetImage(AppAssets.earthBackground),
      rotationSpeed: 0.015,
      isRotating: true,
      isZoomEnabled: true,
      zoom: 0.5,
      minZoom: 0.1,
      maxZoom: 2.5,
      isBackgroundFollowingSphereRotation: true,
      showAtmosphere: true,
      atmosphereOpacity: 0.25,
      surfaceLightingEnabled: true,
      ambientLight: 0.65,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> showCurrentLocation() async {
    if (_isLoadingLocation) return;

    final translations = AppLocalizations.of(context);

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final location = await _locationService.getCurrentLocation();

      final coordinates = GlobeCoordinates(
        location.latitude,
        location.longitude,
      );

      if (!mounted) return;

      if (_hasCurrentLocationPoint) {
        _controller.removePoint(_currentLocationPointId);
        _controller.removePoint(_currentLocationGlowPointId);
      }

      final markerColor = Theme.of(context).colorScheme.primary;

      _controller.addPoint(
        Point(
          id: _currentLocationGlowPointId,
          coordinates: coordinates,
          isLabelVisible: false,
          style: PointStyle(
            color: markerColor.withValues(alpha: 0.22),
            size: 4.8,
            altitude: 0.025,
            transitionDuration: 500,
          ),
        ),
      );

      _controller.addPoint(
        Point(
          id: _currentLocationPointId,
          coordinates: coordinates,
          isLabelVisible: false,
          style: const PointStyle(
            color: Color(0xFFB9F6FF),
            size: 1.8,
            altitude: 0.04,
            transitionDuration: 500,
          ),
        ),
      );

      setState(() {
        _currentLocation = location;
        _hasCurrentLocationPoint = true;
      });

      _controller.stopRotation();
      _controller.setZoom(0.72);
      _controller.focusOnCoordinates(
        coordinates,
        animate: true,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOutCubic,
      );
    } on DeviceLocationException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getLocationErrorMessage(context, error.type))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  String getLocationErrorMessage(
    BuildContext context,
    DeviceLocationFailureType type,
  ) {
    final translations = AppLocalizations.of(context);

    switch (type) {
      case DeviceLocationFailureType.serviceDisabled:
        return translations.locationServiceDisabled;
      case DeviceLocationFailureType.permissionDenied:
        return translations.locationPermissionDenied;
      case DeviceLocationFailureType.permissionDeniedForever:
        return translations.locationPermissionDeniedForever;
      case DeviceLocationFailureType.unknown:
        return translations.locationUnknownError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translations.map),
        actions: [
          IconButton(
            onPressed: _controller.toggleRotation,
            icon: const Icon(Icons.threesixty),
          ),
          IconButton(
            tooltip: translations.showCurrentLocation,
            onPressed: _isLoadingLocation ? null : showCurrentLocation,
            icon: _isLoadingLocation
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortestSide = constraints.maxWidth < constraints.maxHeight
                ? constraints.maxWidth
                : constraints.maxHeight;

            final radius = shortestSide * 0.42;

            const globeOffsetY = -50.0;
            const extraRenderHeight = 120.0;

            return Stack(
              fit: StackFit.expand,
              children: [
                ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    minWidth: constraints.maxWidth,
                    maxWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight + extraRenderHeight,
                    maxHeight: constraints.maxHeight + extraRenderHeight,
                    child: Transform.translate(
                      offset: const Offset(0, globeOffsetY),
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight + extraRenderHeight,
                        child: Center(
                          child: FlutterEarthGlobe(
                            controller: _controller,
                            radius: radius,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_currentLocation != null)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: _CurrentLocationCard(
                      title: translations.currentLocation,
                      location: _currentLocation!,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CurrentLocationCard extends StatelessWidget {
  final String title;
  final DeviceLocation location;

  const _CurrentLocationCard({required this.title, required this.location});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface.withValues(alpha: 0.88),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.my_location,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${location.latitude.toStringAsFixed(4)}, '
                    '${location.longitude.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
