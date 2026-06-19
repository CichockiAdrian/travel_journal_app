import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/di/service_locator.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/device_location_service.dart';
import '../logic/map_cubit.dart';
import '../logic/map_state.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MapCubit>()..loadInitialLocation(),
      child: const _MapView(),
    );
  }
}

class _MapView extends StatefulWidget {
  const _MapView();

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  static const String _currentLocationPointId = 'current-location';
  static const String _currentLocationGlowPointId = 'current-location-glow';

  static const double _initialZoom = 0.5;
  static const double _minZoom = 0.1;
  static const double _maxZoom = 2.5;
  static const double _zoomStep = 0.2;

  late final FlutterEarthGlobeController _controller;

  bool _hasCurrentLocationPoint = false;
  double _currentZoom = _initialZoom;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateZoom(double zoom) {
    final newZoom = zoom.clamp(_minZoom, _maxZoom).toDouble();

    setState(() {
      _currentZoom = newZoom;
    });

    _controller.setZoom(newZoom);
  }

  void zoomIn(BuildContext context) {
    context.read<MapCubit>().hideCurrentLocationCard();
    updateZoom(_currentZoom + _zoomStep);
  }

  void zoomOut(BuildContext context) {
    context.read<MapCubit>().hideCurrentLocationCard();
    updateZoom(_currentZoom - _zoomStep);
  }

  void upsertCurrentLocationPoint(
    BuildContext context,
    DeviceLocation location,
  ) {
    final coordinates = GlobeCoordinates(location.latitude, location.longitude);

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

    _hasCurrentLocationPoint = true;
  }

  void focusOnCurrentLocation(DeviceLocation location) {
    final coordinates = GlobeCoordinates(location.latitude, location.longitude);

    _controller.stopRotation();
    updateZoom(0.72);
    _controller.focusOnCoordinates(
      coordinates,
      animate: true,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
    );
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

    return MultiBlocListener(
      listeners: [
        BlocListener<MapCubit, MapState>(
          listenWhen: (previous, current) {
            return previous.currentLocation != current.currentLocation &&
                current.currentLocation != null;
          },
          listener: (context, state) {
            upsertCurrentLocationPoint(context, state.currentLocation!);
          },
        ),
        BlocListener<MapCubit, MapState>(
          listenWhen: (previous, current) {
            return previous.focusRequestId != current.focusRequestId &&
                current.currentLocation != null;
          },
          listener: (context, state) {
            focusOnCurrentLocation(state.currentLocation!);
          },
        ),
        BlocListener<MapCubit, MapState>(
          listenWhen: (previous, current) {
            return previous.locationErrorType != current.locationErrorType &&
                current.locationErrorType != null;
          },
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  getLocationErrorMessage(context, state.locationErrorType!),
                ),
              ),
            );

            context.read<MapCubit>().clearLocationError();
          },
        ),
      ],
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(translations.map),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<MapCubit>().hideCurrentLocationCard();
                    _controller.toggleRotation();
                  },
                  icon: const Icon(Icons.threesixty),
                ),
                IconButton(
                  tooltip: translations.showCurrentLocation,
                  onPressed: state.isLoadingLocation
                      ? null
                      : context.read<MapCubit>().refreshCurrentLocation,
                  icon: state.isLoadingLocation
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
                  final shortestSide =
                      constraints.maxWidth < constraints.maxHeight
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
                                    context
                                        .read<MapCubit>()
                                        .hideCurrentLocationCard();
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
                        child: _MapZoomControls(
                          onZoomOut: () => zoomOut(context),
                          onZoomIn: () => zoomIn(context),
                        ),
                      ),
                      if (state.currentLocation != null &&
                          state.isCurrentLocationCardVisible)
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: _CurrentLocationCard(
                            title: translations.currentLocation,
                            location: state.currentLocation!,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
        },
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
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.primary.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colorScheme.onPrimary.withValues(alpha: 0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
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
              color: colorScheme.onPrimary,
            ),
            SizedBox(
              height: 22,
              child: VerticalDivider(
                width: 1,
                thickness: 1,
                color: colorScheme.onPrimary.withValues(alpha: 0.35),
              ),
            ),
            IconButton(
              onPressed: onZoomIn,
              icon: const Icon(Icons.add),
              color: colorScheme.onPrimary,
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
