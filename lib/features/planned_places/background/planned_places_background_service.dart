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
  final hasPermission = await _canUseLocation();
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

  service.on('stopService').listen((_) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 60), (_) async {
    final canUseLocation = await _canUseLocation();
    if (!canUseLocation) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final targets = _loadTargets(prefs);
    if (targets.isEmpty) {
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
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

    await prefs.setStringList(_notifiedPlaceIdsKey, notifiedPlaceIds.toList());

    if (service is AndroidServiceInstance) {
      await service.setForegroundNotificationInfo(
        title: 'Travel Journal',
        content: 'Checking nearby planned places',
      );
    }
  });
}

Future<bool> _canUseLocation() async {
  final isServiceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isServiceEnabled) {
    return false;
  }

  var permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
}

List<_BackgroundPlannedPlaceTarget> _loadTargets(SharedPreferences prefs) {
  final encodedTargets =
      prefs.getStringList(PlannedPlacesBackgroundTargetStorage.targetsKey) ??
      [];

  return encodedTargets.map((encodedTarget) {
    final json = jsonDecode(encodedTarget) as Map<String, dynamic>;

    return _BackgroundPlannedPlaceTarget(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusMeters: (json['radiusMeters'] as num).toDouble(),
    );
  }).toList();
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
