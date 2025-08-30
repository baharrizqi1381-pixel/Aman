import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (payload) async {});
  }

  Future<void> scheduleDailyFiveAM() async {
    final now = DateTime.now();
    DateTime scheduled = DateTime(now.year, now.month, now.day, 5, 0);
    if (now.isAfter(scheduled) || now.isAtSameMomentAs(scheduled)) scheduled = scheduled.add(const Duration(days: 1));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Game Dimulai',
      'Buka aplikasi untuk melihat jadwal harianmu',
      tz.TZDateTime.from(scheduled, tz.local),
      const NotificationDetails(android: AndroidNotificationDetails('daily_5am_channel', 'Daily 05:00', channelDescription: 'Daily alarm for game', importance: Importance.max, priority: Priority.high, playSound: true)),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void showAlarmNotification() async {
    const details = NotificationDetails(android: AndroidNotificationDetails('alarm_channel', 'Alarm', channelDescription: 'Alarm fired', importance: Importance.max, priority: Priority.high, playSound: true));
    await flutterLocalNotificationsPlugin.show(1, 'Alarm 05:00', 'Game dimulai. Buka aplikasi untuk melihat jadwal hari ini.', details);
  }
}
