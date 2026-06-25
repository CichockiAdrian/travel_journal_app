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
import '../../planned_places/data/planned_place_model.dart';
import '../../planned_places/data/planned_places_repository.dart';
import '../../planned_places/logic/planned_places_cubit.dart';
import '../../planned_places/logic/planned_places_state.dart';
import '../../planned_places/presentation/planned_place_details_bottom_sheet.dart';
import '../../planned_places/presentation/planned_place_form_bottom_sheet.dart';
import '../../visited_countries/data/visited_countries_repository.dart';
import '../../visited_countries/data/visited_country_model.dart';
import '../../visited_countries/data/visited_countries_repository.dart';
import '../../visited_countries/data/visited_country_model.dart';
import '../../visited_countries/logic/visited_countries_cubit.dart';
import '../../visited_countries/logic/visited_countries_state.dart';
import '../data/device_location_service.dart';
import '../logic/map_cubit.dart';
import '../logic/map_state.dart';
import '../../planned_places/data/planned_place_distance_calculator.dart';
import '../../planned_places/notifications/planned_places_notification_service.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MapCubit(
            getIt<DeviceLocationService>(),
            getIt<VisitedCountriesRepository>(),
          )..loadInitialLocation(),
        ),
        BlocProvider(
          create: (_) => PlannedPlacesCubit(
            getIt<PlannedPlacesRepository>(),
            getIt<PlannedPlaceDistanceCalculator>(),
          ),
          create: (_) =>
              MapCubit(getIt<DeviceLocationService>())..loadInitialLocation(),
        ),
        BlocProvider(
          create: (_) =>
              VisitedCountriesCubit(getIt<VisitedCountriesRepository>())
                ..watchVisitedCountries(),
        ),
      ],
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
  bool _areVisitedCountryPinsVisible = true;

  double _currentZoom = _initialZoom;

  final Set<String> _visitedCountryPointIds = <String>{};

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
    getIt<PlannedPlacesNotificationService>().initialize();
  }

  @override
  void dispose() {
    _globeController.dispose();
    _flatMapController.dispose();
    removeVisitedCountryPoints();

    if (_hasCurrentLocationPoint) {
      _controller.removePoint(_currentLocationPointId);
      _controller.removePoint(_currentLocationGlowPointId);
    }

    _controller.dispose();
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
  void removeVisitedCountryPoints() {
    for (final pointId in _visitedCountryPointIds) {
      _controller.removePoint(pointId);
    }

    _visitedCountryPointIds.clear();
  }

  void toggleVisitedCountryPins(
    BuildContext context,
    List<VisitedCountryModel> countries,
  ) {
    final shouldShowPins = !_areVisitedCountryPinsVisible;

    setState(() {
      _areVisitedCountryPinsVisible = shouldShowPins;
    });

    if (shouldShowPins) {
      syncVisitedCountryPoints(context, countries);
    } else {
      removeVisitedCountryPoints();
    }
  }

  void syncVisitedCountryPoints(
    BuildContext context,
    List<VisitedCountryModel> countries,
  ) {
    removeVisitedCountryPoints();

    if (!_areVisitedCountryPinsVisible) {
      return;
    }

    final translations = AppLocalizations.of(context);

    for (final country in countries) {
      final latitude = country.latitude;
      final longitude = country.longitude;

      if (latitude == null || longitude == null) {
        continue;
      }

      final pointId = '$_visitedCountryPointPrefix${country.id}';
      final glowPointId = '$pointId-glow';
      final countryName = country.name ?? translations.unknownCountry;
      final coordinates = GlobeCoordinates(latitude, longitude);

      void showCountryName() {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(countryName),
              duration: const Duration(seconds: 2),
            ),
          );
      }

      _controller.addPoint(
        Point(
          id: glowPointId,
          coordinates: coordinates,
          label: countryName,
          isLabelVisible: false,
          onTap: showCountryName,
          style: const PointStyle(
            color: Color(0x66E53935),
            size: 4.2,
            altitude: 0.025,
            transitionDuration: 500,
          ),
        ),
      );

      _controller.addPoint(
        Point(
          id: pointId,
          coordinates: coordinates,
          label: countryName,
          isLabelVisible: false,
          onTap: showCountryName,
          style: const PointStyle(
            color: Color(0xFFE53935),
            size: 2.0,
            altitude: 0.05,
            transitionDuration: 500,
          ),
        ),
      );

      _visitedCountryPointIds
        ..add(glowPointId)
        ..add(pointId);
    }
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

  void _openAddPlannedPlaceBottomSheet(BuildContext context, LatLng point) {
    context.read<MapCubit>().hideCurrentLocationCard();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<PlannedPlacesCubit>(),
          child: PlannedPlaceFormBottomSheet(
            latitude: point.latitude,
            longitude: point.longitude,
          ),
        );
      },
    );
  }

  void _openPlannedPlaceDetailsBottomSheet(
    BuildContext context,
    PlannedPlaceModel place,
  ) {
    context.read<MapCubit>().hideCurrentLocationCard();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<PlannedPlacesCubit>(),
          child: PlannedPlaceDetailsBottomSheet(
            place: place,
            distanceText: _getPlannedPlaceDistanceText(context, place.id),
          ),
        );
      },
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

  String _getPlannedPlacesErrorMessage(
    BuildContext context,
    PlannedPlacesFailureType type,
  String getVisitedCountriesErrorMessage(
    BuildContext context,
    VisitedCountriesFailureType type,
  ) {
    final translations = AppLocalizations.of(context);

    switch (type) {
      case PlannedPlacesFailureType.notAuthenticated:
        return translations.signInToSyncPlannedPlaces;
      case PlannedPlacesFailureType.invalidTitle:
        return translations.plannedPlaceTitleRequired;
      case PlannedPlacesFailureType.invalidCoordinates:
        return translations.locationUnknownError;
      case PlannedPlacesFailureType.unknown:
        return translations.plannedPlaceSaveFailed;
      case VisitedCountriesFailureType.notAuthenticated:
        return translations.signInToSyncVisitedCountries;
      case VisitedCountriesFailureType.missingCountryId:
        return translations.countryCannotBeMarkedAsVisited;
      case VisitedCountriesFailureType.unknown:
        return translations.visitedCountriesSyncFailed;
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
            final currentLocation = state.currentLocation!;

            _upsertCurrentLocationPoint(context, currentLocation);
            context.read<PlannedPlacesCubit>().updateCurrentLocation(
              currentLocation,
            );
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
        BlocListener<VisitedCountriesCubit, VisitedCountriesState>(
          listenWhen: (previous, current) {
            return previous.visitedCountries != current.visitedCountries;
          },
          listener: (context, state) {
            _syncVisitedCountryPoints(context, state.visitedCountries);
          },
        ),
        BlocListener<PlannedPlacesCubit, PlannedPlacesState>(
            syncVisitedCountryPoints(context, state.visitedCountries);
          },
        ),
        BlocListener<VisitedCountriesCubit, VisitedCountriesState>(
          listenWhen: (previous, current) {
            return previous.failureType != current.failureType &&
                current.failureType != null;
          },
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _getPlannedPlacesErrorMessage(context, state.failureType!),
                ),
              ),
            );

            context.read<PlannedPlacesCubit>().clearFailure();
          },
        ),
        BlocListener<PlannedPlacesCubit, PlannedPlacesState>(
          listenWhen: (previous, current) {
            return previous.actionFailureType != current.actionFailureType &&
                current.actionFailureType != null;
          },
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _getPlannedPlacesErrorMessage(
                    context,
                    state.actionFailureType!,
                  ),
                ),
              ),
            );

            context.read<PlannedPlacesCubit>().clearFailure();
          },
        ),
        BlocListener<PlannedPlacesCubit, PlannedPlacesState>(
          listenWhen: (previous, current) {
            return previous.pendingNearbyNotificationPlace !=
                    current.pendingNearbyNotificationPlace &&
                current.pendingNearbyNotificationPlace != null &&
                current.pendingNearbyNotificationDistanceInMeters != null;
          },
          listener: (context, state) async {
            final place = state.pendingNearbyNotificationPlace!;
            final distance = state.pendingNearbyNotificationDistanceInMeters!;
            final formattedDistance = _formatDistance(context, distance);
            final translations = AppLocalizations.of(context);

            await getIt<PlannedPlacesNotificationService>()
                .showNearbyPlannedPlaceNotification(
                  placeId: place.id,
                  title: translations.nearbyPlannedPlaceNotificationTitle(
                    place.title,
                  ),
                  body: translations.nearbyPlannedPlaceNotificationBody(
                    formattedDistance,
                  ),
                );

            if (!context.mounted) {
              return;
            }

            context.read<PlannedPlacesCubit>().clearPendingNearbyNotification();
                  getVisitedCountriesErrorMessage(context, state.failureType!),
                ),
              ),
            );

            context.read<VisitedCountriesCubit>().clearFailure();
          },
        ),
      ],
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          final plannedPlaces = context
              .watch<PlannedPlacesCubit>()
              .state
              .places;

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
                            plannedPlaces: plannedPlaces,
                            onMapTap: () {
                              context
                                  .read<MapCubit>()
                                  .hideCurrentLocationCard();
                            },
                            onMapLongPress: (point) {
                              _openAddPlannedPlaceBottomSheet(context, point);
                            },
                            onVisitedCountryTap: (_) {
                              context
                                  .read<MapCubit>()
                                  .hideCurrentLocationCard();
                            },
                            onPlannedPlaceTap: (place) {
                              _openPlannedPlaceDetailsBottomSheet(
                                context,
                                place,
                              );
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
        builder: (context, mapState) {
          return BlocBuilder<VisitedCountriesCubit, VisitedCountriesState>(
            builder: (context, visitedCountriesState) {
              final visitedCountriesCount =
                  visitedCountriesState.visitedCountriesWithCoordinatesCount;

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
                      onPressed: mapState.isLoadingLocation
                          ? null
                          : context.read<MapCubit>().refreshCurrentLocation,
                      icon: mapState.isLoadingLocation
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
                              minHeight:
                                  constraints.maxHeight + extraRenderHeight,
                              maxHeight:
                                  constraints.maxHeight + extraRenderHeight,
                              child: Transform.translate(
                                offset: const Offset(0, globeOffsetY),
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  height:
                                      constraints.maxHeight + extraRenderHeight,
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
                          Positioned(
                            right: 16,
                            top: 16,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth * 0.58,
                              ),
                              child: _VisitedCountriesCard(
                                title: _areVisitedCountryPinsVisible
                                    ? translations.hideVisitedCountries
                                    : translations.showVisitedCountries,
                                subtitle: translations.visitedCountriesCount(
                                  visitedCountriesCount,
                                ),
                                isLoading:
                                    visitedCountriesState.status ==
                                    VisitedCountriesStatus.loading,
                                arePinsVisible: _areVisitedCountryPinsVisible,
                                onTogglePins: () {
                                  toggleVisitedCountryPins(
                                    context,
                                    visitedCountriesState.visitedCountries,
                                  );
                                },
                              ),
                            ),
                          ),
                          if (mapState.currentLocation != null &&
                              mapState.isCurrentLocationCardVisible)
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: _CurrentLocationCard(
                                title: translations.currentLocation,
                                location: mapState.currentLocation!,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
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

  String _formatDistance(BuildContext context, double distanceInMeters) {
    final translations = AppLocalizations.of(context);

    if (distanceInMeters >= 1000) {
      final distanceInKilometers = distanceInMeters / 1000;

      return translations.distanceKilometers(
        distanceInKilometers.toStringAsFixed(1),
      );
    }

    return translations.distanceMeters(distanceInMeters.round());
  }

  String? _getPlannedPlaceDistanceText(BuildContext context, String placeId) {
    final distance = context
        .read<PlannedPlacesCubit>()
        .state
        .distanceByPlaceId[placeId];

    if (distance == null) {
      return null;
    }

    return _formatDistance(context, distance);
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
  final List<PlannedPlaceModel> plannedPlaces;
  final VoidCallback onMapTap;
  final ValueChanged<LatLng> onMapLongPress;
  final ValueChanged<VisitedCountryModel> onVisitedCountryTap;
  final ValueChanged<PlannedPlaceModel> onPlannedPlaceTap;

  const _FlatMapView({
    super.key,
    required this.controller,
    required this.currentLocation,
    required this.visitedCountries,
    required this.plannedPlaces,
    required this.onMapTap,
    required this.onMapLongPress,
    required this.onVisitedCountryTap,
    required this.onPlannedPlaceTap,
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
            child: GestureDetector(
              onTap: () => onVisitedCountryTap(country),
              child: _VisitedCountryMapMarker(country: country),
            ),
          ),
        );

    final plannedPlaceMarkers = plannedPlaces.map((place) {
      return Marker(
        point: LatLng(place.latitude, place.longitude),
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () => onPlannedPlaceTap(place),
          child: _PlannedPlaceMapMarker(place: place),
        ),
      );
    });

    final markers = <Marker>[
      ...visitedCountryMarkers,
      ...plannedPlaceMarkers,
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
        onLongPress: (_, point) => onMapLongPress(point),
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

class _PlannedPlaceMapMarker extends StatelessWidget {
  final PlannedPlaceModel place;

  const _PlannedPlaceMapMarker({required this.place});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = place.isCompleted
        ? colorScheme.tertiaryContainer
        : colorScheme.primaryContainer;

    final iconColor = place.isCompleted
        ? colorScheme.onTertiaryContainer
        : colorScheme.onPrimaryContainer;

    return Tooltip(
      message: place.title,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: place.isCompleted
                ? colorScheme.tertiary
                : colorScheme.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.24),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          place.isCompleted ? Icons.check : Icons.flag_outlined,
          size: 20,
          color: iconColor,
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

class _VisitedCountriesCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isLoading;
  final bool arePinsVisible;
  final VoidCallback onTogglePins;

  const _VisitedCountriesCard({
    required this.title,
    required this.subtitle,
    required this.isLoading,
    required this.arePinsVisible,
    required this.onTogglePins,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const activeColor = Color(0xFFE53935);

    return Card(
      elevation: 0,
      color: colorScheme.surface.withValues(alpha: 0.88),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: arePinsVisible
              ? activeColor.withValues(alpha: 0.45)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTogglePins,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 14,
            top: 10,
            bottom: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flag,
                size: 19,
                color: arePinsVisible
                    ? activeColor
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 9),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading) ...[
                const SizedBox(width: 10),
                const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
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
