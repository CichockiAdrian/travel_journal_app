import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/planned_places_nearby_checker.dart';
import '../notifications/planned_places_notification_service.dart';

class PlannedPlacesStartupChecker extends StatefulWidget {
  final Widget child;

  const PlannedPlacesStartupChecker({super.key, required this.child});

  @override
  State<PlannedPlacesStartupChecker> createState() {
    return _PlannedPlacesStartupCheckerState();
  }
}

class _PlannedPlacesStartupCheckerState
    extends State<PlannedPlacesStartupChecker> {
  bool _hasCheckedNearbyPlaces = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasCheckedNearbyPlaces) {
      return;
    }

    _hasCheckedNearbyPlaces = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNearbyPlacesOnStartup();
    });
  }

  Future<void> _checkNearbyPlacesOnStartup() async {
    if (!mounted) {
      return;
    }

    final translations = AppLocalizations.of(context);

    await getIt<PlannedPlacesNotificationService>().initialize();

    final result = await getIt<PlannedPlacesNearbyChecker>()
        .checkNearestNearbyPlace();

    if (!mounted || result == null) {
      return;
    }

    final distanceText = _formatDistance(translations, result.distanceInMeters);

    await getIt<PlannedPlacesNotificationService>()
        .showNearbyPlannedPlaceNotification(
          placeId: result.place.id,
          title: translations.nearbyPlannedPlaceNotificationTitle(
            result.place.title,
          ),
          body: translations.nearbyPlannedPlaceNotificationBody(distanceText),
        );
  }

  String _formatDistance(
    AppLocalizations translations,
    double distanceInMeters,
  ) {
    if (distanceInMeters >= 1000) {
      final distanceInKilometers = distanceInMeters / 1000;

      return translations.distanceKilometers(
        distanceInKilometers.toStringAsFixed(1),
      );
    }

    return translations.distanceMeters(distanceInMeters.round());
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
