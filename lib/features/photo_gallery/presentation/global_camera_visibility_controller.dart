import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class GlobalCameraVisibilityController {
  static final ValueNotifier<int> _hiddenRequests = ValueNotifier<int>(0);

  static int _hiddenRequestsCount = 0;
  static bool _notificationScheduled = false;

  static ValueListenable<int> get hiddenRequests => _hiddenRequests;

  static void hide() {
    _hiddenRequestsCount++;
    _scheduleNotification();
  }

  static void show() {
    if (_hiddenRequestsCount == 0) {
      return;
    }

    _hiddenRequestsCount--;
    _scheduleNotification();
  }

  static void _scheduleNotification() {
    if (_notificationScheduled) {
      return;
    }

    _notificationScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationScheduled = false;

      if (_hiddenRequests.value == _hiddenRequestsCount) {
        return;
      }

      _hiddenRequests.value = _hiddenRequestsCount;
    });
  }
}
