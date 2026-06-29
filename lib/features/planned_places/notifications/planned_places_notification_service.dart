import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PlannedPlacesNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<String> _notificationTapController =
      StreamController<String>.broadcast();

  bool _isInitialized = false;

  Stream<String> get notificationTapStream {
    return _notificationTapController.stream;
  }

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;

          if (payload == null || payload.isEmpty) {
            return;
          }

          _notificationTapController.add(payload);
        },
      );

      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      _isInitialized = true;
    } on MissingPluginException {
      _isInitialized = false;
    }
  }

  Future<void> showNearbyPlannedPlaceNotification({
    required String placeId,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (!_isInitialized) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'nearby_planned_places',
      'Nearby planned places',
      channelDescription: 'Notifications shown near planned map places.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _plugin.show(
        id: placeId.hashCode.abs(),
        title: title,
        body: body,
        notificationDetails: details,
        payload: placeId,
      );
    } on MissingPluginException {
      return;
    }
  }

  Future<void> dispose() async {
    await _notificationTapController.close();
  }
}
