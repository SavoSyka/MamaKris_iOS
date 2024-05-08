// notification.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeLocalNotifications() async {
  print('init');
  // Initialize timezone data
  tz.initializeTimeZones();

  // iOS-specific initialization settings
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // General initialization settings
  const InitializationSettings initializationSettings = InitializationSettings(
    iOS: initializationSettingsIOS, // Using only iOS settings
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}



Future<void> scheduleRepeatingNotification() async {
  const NotificationDetails notificationDetails = NotificationDetails(
    iOS: DarwinNotificationDetails(),
  );

  await flutterLocalNotificationsPlugin.periodicallyShow(
    0,
    'MamaKris',
    'Новые свежие вакансии на удаленке ждут тебя 👍',
    RepeatInterval.daily,
    notificationDetails,
  );
}

tz.TZDateTime _nextInstanceOfFiveSeconds() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  return now.add(const Duration(seconds: 5));
}
