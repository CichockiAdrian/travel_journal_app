import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';

import '../../../core/constants/app_assets.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/device_location_service.dart';
import '../../../core/theme/map_controls_theme.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const String _currentLocationPointId = 'current-location';
  static const String _currentLocationGlowPointId = 'current-location-glow';
  static const double _initialZoom = 0.5;
  static const double _minZoom = 0.1;
  static const double _maxZoom = 2.5;
  static const double _zoomStep = 0.2;

  late final FlutterEarthGlobeController _controller;
  final DeviceLocationService _locationService = DeviceLocationService();

  bool _isLoadingLocation = false;
  bool _hasCurrentLocationPoint = false;
  bool _isCurrentLocationCardVisible = false;

  double _currentZoom = _initialZoom;
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
      zoom: _initialZoom,
      minZoom: _minZoom,
      maxZoom: _maxZoom,
      isBackgroundFollowingSphereRotation: true,
      showAtmosphere: true,
      atmosphereOpacity: 0.25,
      surfaceLightingEnabled: true,
      ambientLight: 0.65,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCurrentLocation(showCardAfterLoad: false, focusAfterLoad: false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void hideCurrentLocationCard() {
    if (!_isCurrentLocationCardVisible) return;

    setState(() {
      _isCurrentLocationCardVisible = false;
    });
  }

  void updateZoom(double zoom) {
    final newZoom = zoom.clamp(_minZoom, _maxZoom).toDouble();

    setState(() {
      _currentZoom = newZoom;
    });

    _controller.setZoom(newZoom);
  }

  void zoomIn() {
    hideCurrentLocationCard();
    updateZoom(_currentZoom + _zoomStep);
  }

  void zoomOut() {
    hideCurrentLocationCard();
    updateZoom(_currentZoom - _zoomStep);
  }

  void focusOnCurrentLocation() {
    final currentLocation = _currentLocation;

    if (currentLocation == null) return;

    final coordinates = GlobeCoordinates(
      currentLocation.latitude,
      currentLocation.longitude,
    );

    setState(() {
      _isCurrentLocationCardVisible = true;
    });

    _controller.stopRotation();
    updateZoom(0.72);
    _controller.focusOnCoordinates(
      coordinates,
      animate: true,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> handleCurrentLocationButtonPressed() async {
    await loadCurrentLocation(showCardAfterLoad: true, focusAfterLoad: true);
  }

  Future<void> loadCurrentLocation({
    required bool showCardAfterLoad,
    required bool focusAfterLoad,
  }) async {
    if (_isLoadingLocation) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final location = await _locationService.getCurrentLocation();

      if (!mounted) return;

      final coordinates = GlobeCoordinates(
        location.latitude,
        location.longitude,
      );

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
        _isCurrentLocationCardVisible = showCardAfterLoad;
      });

      if (focusAfterLoad) {
        _controller.stopRotation();
        _controller.setZoom(0.72);
        _controller.focusOnCoordinates(
          coordinates,
          animate: true,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOutCubic,
        );
      }
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
            onPressed: () {
              hideCurrentLocationCard();
              _controller.toggleRotation();
            },
            icon: const Icon(Icons.threesixty),
          ),
          IconButton(
            tooltip: translations.showCurrentLocation,
            onPressed: _isLoadingLocation
                ? null
                : handleCurrentLocationButtonPressed,
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
                          child: Listener(
                            onPointerDown: (_) {
                              hideCurrentLocationCard();
                            },
                            child: FlutterEarthGlobe(
                              controller: _controller,
                              radius: radius,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: _MapZoomControls(onZoomOut: zoomOut, onZoomIn: zoomIn),
                ),
                if (_currentLocation != null && _isCurrentLocationCardVisible)
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

class _MapZoomControls extends StatelessWidget {
  final VoidCallback onZoomOut;
  final VoidCallback onZoomIn;

  const _MapZoomControls({required this.onZoomOut, required this.onZoomIn});

  @override
  Widget build(BuildContext context) {
    final controlsTheme = Theme.of(context).extension<MapControlsTheme>()!;
    final borderRadius = BorderRadius.circular(controlsTheme.borderRadius);

    return Material(
      color: controlsTheme.backgroundColor,
      borderRadius: borderRadius,
      child: Container(
        height: controlsTheme.height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(color: controlsTheme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: controlsTheme.shadowOpacity,
              ),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onZoomOut,
              icon: const Icon(Icons.remove),
              color: controlsTheme.foregroundColor,
            ),
            SizedBox(
              height: 22,
              child: VerticalDivider(
                width: 1,
                thickness: 1,
                color: controlsTheme.dividerColor,
              ),
            ),
            IconButton(
              onPressed: onZoomIn,
              icon: const Icon(Icons.add),
              color: controlsTheme.foregroundColor,
            ),
          ],
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
