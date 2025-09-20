// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//   FlutterLocalNotificationsPlugin();
//
//   static Future<void> init() async {
//     // Initialize timezone (needed for scheduled notifications)
//     tz.initializeTimeZones();
//
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosInit = DarwinInitializationSettings();
//
//     const initSettings = InitializationSettings(
//       android: androidInit,
//       iOS: iosInit,
//     );
//
//     await _notifications.initialize(initSettings);
//   }
//
//   static Future<void> showInstantNotification(
//       int id, String title, String body) async {
//     const details = NotificationDetails(
//       android: AndroidNotificationDetails(
//         'task_channel',
//         'Task Notifications',
//         channelDescription: 'Reminders for your tasks',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//
//     await _notifications.show(id, title, body, details);
//   }
//
//   static Future<void> scheduleNotification(
//       int id, String title, String body, DateTime scheduledTime) async {
//     const details = NotificationDetails(
//       android: AndroidNotificationDetails(
//         'task_channel',
//         'Task Notifications',
//         channelDescription: 'Reminders for your tasks',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//
//     await _notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       details,
//        androidScheduleMode: AndroidScheduleMode.alarmClock,
//     );
//   }
//
//   static Future<void> cancelNotification(int id) async {
//     await _notifications.cancel(id);
//   }
// }
