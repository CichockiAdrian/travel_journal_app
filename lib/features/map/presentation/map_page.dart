import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/di/service_locator.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/device_location_service.dart';
import '../logic/map_cubit.dart';
import '../logic/map_state.dart';
import '../../visited_countries/data/visited_countries_repository.dart';
import '../../visited_countries/data/visited_country_model.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapCubit(
        getIt<DeviceLocationService>(),
        getIt<VisitedCountriesRepository>(),
      )..loadInitialLocation(),
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
  static const String _visitedCountryPointPrefix = 'visited-country-';

  final Set<String> _renderedVisitedCountryPointIds = {};

  static const double _initialGlobeZoom = 0.5;
  static const double _minGlobeZoom = 0.1;
  static const double _maxGlobeZoom = 2.5;
  static const double _globeZoomStep = 0.2;

  static const double _initialFlatMapZoom = 3;
  static const double _focusedFlatMapZoom = 15;
  static const double _minFlatMapZoom = 2;
  static const double _maxFlatMapZoom = 18;
  static const double _flatMapZoomStep = 1;

  static const LatLng _defaultFlatMapCenter = LatLng(20, 0);

  late final FlutterEarthGlobeController _globeController;
  late final MapController _flatMapController;

  bool _hasCurrentLocationPoint = false;
  double _currentGlobeZoom = _initialGlobeZoom;

  @override
  void initState() {
    super.initState();

    _globeController = FlutterEarthGlobeController(
      surface: const AssetImage(AppAssets.earthSurface),
      background: const AssetImage(AppAssets.earthBackground),
      rotationSpeed: 0.015,
      isRotating: true,
      isZoomEnabled: true,
      zoom: _initialGlobeZoom,
      minZoom: _minGlobeZoom,
      maxZoom: _maxGlobeZoom,
      isBackgroundFollowingSphereRotation: true,
      showAtmosphere: true,
      atmosphereOpacity: 0.25,
      surfaceLightingEnabled: true,
      ambientLight: 0.65,
    );

    _flatMapController = MapController();
  }

  @override
  void dispose() {
    _globeController.dispose();
    _flatMapController.dispose();
    super.dispose();
  }

  void _updateGlobeZoom(double zoom) {
    final newZoom = zoom.clamp(_minGlobeZoom, _maxGlobeZoom).toDouble();

    setState(() {
      _currentGlobeZoom = newZoom;
    });

    _globeController.setZoom(newZoom);
  }

  void _zoomIn(BuildContext context, MapDisplayMode mode) {
    context.read<MapCubit>().hideCurrentLocationCard();

    if (mode == MapDisplayMode.globe) {
      _updateGlobeZoom(_currentGlobeZoom + _globeZoomStep);
      return;
    }

    final camera = _flatMapController.camera;
    final newZoom = (camera.zoom + _flatMapZoomStep)
        .clamp(_minFlatMapZoom, _maxFlatMapZoom)
        .toDouble();

    _flatMapController.move(camera.center, newZoom);
  }

  void _zoomOut(BuildContext context, MapDisplayMode mode) {
    context.read<MapCubit>().hideCurrentLocationCard();

    if (mode == MapDisplayMode.globe) {
      _updateGlobeZoom(_currentGlobeZoom - _globeZoomStep);
      return;
    }

    final camera = _flatMapController.camera;
    final newZoom = (camera.zoom - _flatMapZoomStep)
        .clamp(_minFlatMapZoom, _maxFlatMapZoom)
        .toDouble();

    _flatMapController.move(camera.center, newZoom);
  }

  void _upsertCurrentLocationPoint(
    BuildContext context,
    DeviceLocation location,
  ) {
    final coordinates = GlobeCoordinates(location.latitude, location.longitude);

    if (_hasCurrentLocationPoint) {
      _globeController.removePoint(_currentLocationPointId);
      _globeController.removePoint(_currentLocationGlowPointId);
    }

    final markerColor = Theme.of(context).colorScheme.primary;

    _globeController.addPoint(
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

    _globeController.addPoint(
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

  void _focusOnCurrentLocation(DeviceLocation location, MapDisplayMode mode) {
    if (mode == MapDisplayMode.flat) {
      _flatMapController.move(
        LatLng(location.latitude, location.longitude),
        _focusedFlatMapZoom,
      );
      return;
    }

    final coordinates = GlobeCoordinates(location.latitude, location.longitude);

    _globeController.stopRotation();
    _updateGlobeZoom(0.72);
    _globeController.focusOnCoordinates(
      coordinates,
      animate: true,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
    );
  }

  String _getLocationErrorMessage(
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
            _upsertCurrentLocationPoint(context, state.currentLocation!);
          },
        ),
        BlocListener<MapCubit, MapState>(
          listenWhen: (previous, current) {
            return previous.focusRequestId != current.focusRequestId &&
                current.currentLocation != null;
          },
          listener: (context, state) {
            _focusOnCurrentLocation(
              state.currentLocation!,
              state.mapDisplayMode,
            );
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
                  _getLocationErrorMessage(context, state.locationErrorType!),
                ),
              ),
            );

            context.read<MapCubit>().clearLocationError();
          },
        ),
        BlocListener<MapCubit, MapState>(
          listenWhen: (previous, current) {
            return previous.visitedCountries != current.visitedCountries;
          },
          listener: (context, state) {
            _syncVisitedCountryPoints(context, state.visitedCountries);
          },
        ),
      ],
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(translations.map),
              actions: [
                if (state.mapDisplayMode == MapDisplayMode.globe)
                  IconButton(
                    onPressed: () {
                      context.read<MapCubit>().hideCurrentLocationCard();
                      _globeController.toggleRotation();
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: state.mapDisplayMode == MapDisplayMode.globe
                        ? _GlobeMapView(
                            key: const ValueKey('globe-map'),
                            controller: _globeController,
                            onPointerDown: () {
                              context
                                  .read<MapCubit>()
                                  .hideCurrentLocationCard();
                            },
                          )
                        : _FlatMapView(
                            key: const ValueKey('flat-map'),
                            controller: _flatMapController,
                            currentLocation: state.currentLocation,
                            visitedCountries: state.visitedCountries,
                            onMapTap: () {
                              context
                                  .read<MapCubit>()
                                  .hideCurrentLocationCard();
                            },
                          ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    top: 16,
                    child: _MapModeSwitcher(
                      selectedMode: state.mapDisplayMode,
                      onModeChanged: context.read<MapCubit>().setMapDisplayMode,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 78,
                    child: _MapZoomControls(
                      onZoomOut: () => _zoomOut(context, state.mapDisplayMode),
                      onZoomIn: () => _zoomIn(context, state.mapDisplayMode),
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
              ),
            ),
          );
        },
      ),
    );
  }

  void _syncVisitedCountryPoints(
    BuildContext context,
    List<VisitedCountryModel> visitedCountries,
  ) {
    for (final pointId in _renderedVisitedCountryPointIds) {
      _globeController.removePoint(pointId);
    }

    _renderedVisitedCountryPointIds.clear();

    final colorScheme = Theme.of(context).colorScheme;

    for (final country in visitedCountries) {
      final latitude = country.latitude;
      final longitude = country.longitude;

      if (latitude == null || longitude == null) continue;

      final pointId = '$_visitedCountryPointPrefix${country.id}';

      _globeController.addPoint(
        Point(
          id: pointId,
          coordinates: GlobeCoordinates(latitude, longitude),
          isLabelVisible: false,
          style: PointStyle(
            color: colorScheme.secondary,
            size: 1.45,
            altitude: 0.035,
            transitionDuration: 500,
          ),
        ),
      );

      _renderedVisitedCountryPointIds.add(pointId);
    }
  }
}

class _GlobeMapView extends StatelessWidget {
  final FlutterEarthGlobeController controller;
  final VoidCallback onPointerDown;

  const _GlobeMapView({
    super.key,
    required this.controller,
    required this.onPointerDown,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortestSide = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        final radius = shortestSide * 0.42;

        const globeOffsetY = -50.0;
        const extraRenderHeight = 120.0;

        return ClipRect(
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
                    onPointerDown: (_) => onPointerDown(),
                    child: FlutterEarthGlobe(
                      controller: controller,
                      radius: radius,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FlatMapView extends StatelessWidget {
  final MapController controller;
  final DeviceLocation? currentLocation;
  final List<VisitedCountryModel> visitedCountries;
  final VoidCallback onMapTap;

  const _FlatMapView({
    super.key,
    required this.controller,
    required this.currentLocation,
    required this.visitedCountries,
    required this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    final visitedCountryMarkers = visitedCountries
        .where((country) {
          return country.latitude != null && country.longitude != null;
        })
        .map(
          (country) => Marker(
            point: LatLng(country.latitude!, country.longitude!),
            width: 46,
            height: 46,
            alignment: Alignment.center,
            child: _VisitedCountryMapMarker(country: country),
          ),
        );

    final markers = <Marker>[
      ...visitedCountryMarkers,
      if (currentLocation != null)
        Marker(
          point: LatLng(currentLocation!.latitude, currentLocation!.longitude),
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: _CurrentLocationMapMarker(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
    ];

    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: currentLocation == null
            ? _MapViewState._defaultFlatMapCenter
            : LatLng(currentLocation!.latitude, currentLocation!.longitude),
        initialZoom: currentLocation == null
            ? _MapViewState._initialFlatMapZoom
            : _MapViewState._focusedFlatMapZoom,
        minZoom: _MapViewState._minFlatMapZoom,
        maxZoom: _MapViewState._maxFlatMapZoom,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onTap: (_, _) => onMapTap(),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.traveljournal.app',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}

class _CurrentLocationMapMarker extends StatelessWidget {
  final Color color;

  const _CurrentLocationMapMarker({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VisitedCountryMapMarker extends StatelessWidget {
  final VisitedCountryModel country;

  const _VisitedCountryMapMarker({required this.country});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final countryName = country.name?.trim();

    return Tooltip(
      message: countryName == null || countryName.isEmpty
          ? country.id
          : countryName,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          shape: BoxShape.circle,
          border: Border.all(color: colorScheme.secondary, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.check,
          size: 18,
          color: colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

class _MapModeSwitcher extends StatelessWidget {
  final MapDisplayMode selectedMode;
  final ValueChanged<MapDisplayMode> onModeChanged;

  const _MapModeSwitcher({
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.center,
      child: Material(
        color: colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MapModeButton(
                label: AppLocalizations.of(context).globeMapMode,
                icon: Icons.public,
                isSelected: selectedMode == MapDisplayMode.globe,
                onPressed: () => onModeChanged(MapDisplayMode.globe),
              ),
              _MapModeButton(
                label: AppLocalizations.of(context).flatMapMode,
                icon: Icons.map_outlined,
                isSelected: selectedMode == MapDisplayMode.flat,
                onPressed: () => onModeChanged(MapDisplayMode.flat),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const _MapModeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
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
