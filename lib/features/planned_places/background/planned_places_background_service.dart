import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'planned_places_background_target_storage.dart';

const String plannedPlacesForegroundChannelId =
    'planned_places_foreground_service';

const String nearbyPlannedPlacesChannelId = 'nearby_planned_places';

const int plannedPlacesForegroundNotificationId = 4101;

const String _notifiedPlaceIdsKey = 'notified_background_planned_place_ids';

Future<void> initializePlannedPlacesBackgroundService() async {
  final service = FlutterBackgroundService();
  final notifications = FlutterLocalNotificationsPlugin();

  const foregroundChannel = AndroidNotificationChannel(
    plannedPlacesForegroundChannelId,
    'Planned places background service',
    description: 'Keeps nearby planned place checks active.',
    importance: Importance.low,
  );

  const nearbyChannel = AndroidNotificationChannel(
    nearbyPlannedPlacesChannelId,
    'Nearby planned places',
    description: 'Notifications shown near planned map places.',
    importance: Importance.high,
  );

  await notifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(foregroundChannel);

  await notifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(nearbyChannel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onPlannedPlacesBackgroundServiceStart,
      autoStart: false,
      autoStartOnBoot: true,
      isForegroundMode: true,
      notificationChannelId: plannedPlacesForegroundChannelId,
      initialNotificationTitle: 'Travel Journal',
      initialNotificationContent: 'Checking nearby planned places',
      foregroundServiceNotificationId: plannedPlacesForegroundNotificationId,
      foregroundServiceTypes: const [AndroidForegroundType.location],
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onPlannedPlacesBackgroundServiceStart,
      onBackground: onPlannedPlacesIosBackground,
    ),
  );
}

Future<void> startPlannedPlacesBackgroundService() async {
  final hasPermission = await _canUseBackgroundLocation();

  if (!hasPermission) {
    return;
  }

  final service = FlutterBackgroundService();
  final isRunning = await service.isRunning();

  if (!isRunning) {
    await service.startService();
  }
}

Future<void> stopPlannedPlacesBackgroundService() async {
  FlutterBackgroundService().invoke('stopService');
}

@pragma('vm:entry-point')
Future<bool> onPlannedPlacesIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onPlannedPlacesBackgroundServiceStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final notifications = FlutterLocalNotificationsPlugin();

  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  );

  await notifications.initialize(settings: initializationSettings);

  if (service is AndroidServiceInstance) {
    await service.setAsForegroundService();
  }

  Timer? backgroundTimer;
  bool isTickRunning = false;
  bool isAppForeground = true;

  service.on('stopService').listen((_) {
    backgroundTimer?.cancel();
    service.stopSelf();
  });

  service.on('setAppForeground').listen((event) {
    if (event != null && event['isForeground'] is bool) {
      isAppForeground = event['isForeground'] as bool;
    }
  });

  backgroundTimer = Timer.periodic(const Duration(seconds: 60), (_) async {
    if (isTickRunning) {
      return;
    }

    isTickRunning = true;

    try {
      final canUseLocation = await _canUseBackgroundLocation();

      if (!canUseLocation) {
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final targets = _loadTargets(prefs);

      if (targets.isEmpty) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: isAppForeground
              ? LocationAccuracy.medium
              : LocationAccuracy.low,
        ),
      );

      final notifiedPlaceIds =
          prefs.getStringList(_notifiedPlaceIdsKey)?.toSet() ?? <String>{};

      for (final target in targets) {
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          target.latitude,
          target.longitude,
        );

        final exitDistance = target.radiusMeters + 150;

        if (distance > exitDistance) {
          notifiedPlaceIds.remove(target.id);
          continue;
        }

        if (distance <= target.radiusMeters &&
            !notifiedPlaceIds.contains(target.id)) {
          notifiedPlaceIds.add(target.id);

          await notifications.show(
            id: target.id.hashCode.abs(),
            title: target.title,
            body: target.body,
            notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                nearbyPlannedPlacesChannelId,
                'Nearby planned places',
                channelDescription:
                    'Notifications shown near planned map places.',
                importance: Importance.high,
                priority: Priority.high,
              ),
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: target.id,
          );
        }
      }

      await prefs.setStringList(
        _notifiedPlaceIdsKey,
        notifiedPlaceIds.toList(),
      );

      if (service is AndroidServiceInstance) {
        await service.setForegroundNotificationInfo(
          title: 'Travel Journal',
          content: 'Checking nearby planned places',
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Background location tick failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isTickRunning = false;
    }
  });
}

Future<bool> _canUseBackgroundLocation() async {
  final isServiceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isServiceEnabled) {
    return false;
  }

  final permission = await Geolocator.checkPermission();

  return permission == LocationPermission.always;
}

List<_BackgroundPlannedPlaceTarget> _loadTargets(SharedPreferences prefs) {
  final encodedTargets =
      prefs.getStringList(PlannedPlacesBackgroundTargetStorage.targetsKey) ??
      [];

  final targets = <_BackgroundPlannedPlaceTarget>[];

  for (final encodedTarget in encodedTargets) {
    try {
      final decodedTarget = jsonDecode(encodedTarget) as Map<String, dynamic>;

      targets.add(
        _BackgroundPlannedPlaceTarget(
          id: decodedTarget['id'] as String,
          title: decodedTarget['title'] as String,
          body: decodedTarget['body'] as String,
          latitude: (decodedTarget['latitude'] as num).toDouble(),
          longitude: (decodedTarget['longitude'] as num).toDouble(),
          radiusMeters: (decodedTarget['radiusMeters'] as num).toDouble(),
        ),
      );
    } catch (error) {
      debugPrint('Invalid planned place background target: $error');
    }
  }

  return targets;
}

class _BackgroundPlannedPlaceTarget {
  final String id;
  final String title;
  final String body;
  final double latitude;
  final double longitude;
  final double radiusMeters;

  const _BackgroundPlannedPlaceTarget({
    required this.id,
    required this.title,
    required this.body,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
  });
}
