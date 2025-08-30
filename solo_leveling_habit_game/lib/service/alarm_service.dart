import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'notification_service.dart';

class AlarmService {
  static Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  static void startDailyAlarm() async {
    final now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day, 5, 0);
    if (now.isAfter(start)) start = start.add(const Duration(days: 1));
    await AndroidAlarmManager.oneShotAt(
      start,
      0,
      _alarmCallback,
      exact: true,
      wakeup: true,
    );
    // Also schedule periodic next days
    await AndroidAlarmManager.periodic(const Duration(days: 1), 1, _alarmCallback, exact: true, wakeup: true);
  }

  static void _alarmCallback() {
    debugPrint('Alarm fired at 05:00');
    // trigger a notification so tapping will open the app
    NotificationService().showAlarmNotification();
  }
}
