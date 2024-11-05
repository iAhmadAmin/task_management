import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var indiaTime;

  NotifyHelper() {
    tz.initializeTimeZones(); // Initialize timezone
  }
  Future<void> initNotification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    // Android initialization settings
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    // iOS initialization settings
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);

    // Combined initialization settings
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload != null) {
        debugPrint('notification payload: $payload');
      }
    });

    // Create the notification channel (for Android 8.0+)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'my_channel', // id
          'My Channel', // title
          importance: Importance.max,
          enableVibration: true,
          playSound: true,
        ));
  }

  // Notification details for Android and iOS
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'my_channel',
          'My Channel',
          importance: Importance.max,
          priority: Priority.high,
          visibility: NotificationVisibility.public,
        ),
        iOS: DarwinNotificationDetails());
  }

  Future<void> scheduleNotification(
      DateTime scheduleNotificationDateTime, String title, String body) async {
    print(scheduleNotificationDateTime);
    var androidChannelSpecifics = AndroidNotificationDetails(
      'my_channel2',
      'My Channel2',
      icon: '@mipmap/ic_launcher',
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      autoCancel: false,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ongoing: true,
      timeoutAfter: 5000 * 1000,
      styleInformation: DefaultStyleInformation(true, true),
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
    );

    print(scheduleNotificationDateTime);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        TZDateTime.from(
          scheduleNotificationDateTime,
          local,
        ),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'Test Payload',
        androidScheduleMode: AndroidScheduleMode.alarmClock);
  }

  // Show notification (with optional id and payload)
  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    print("Got notification");
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
      payload: payLoad,
    );
  }

  // Periodically show notifications
  Future<void> periodicallyShowNotification() async {
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Repeating Title',
      'Repeating Body',
      RepeatInterval.everyMinute,
      notificationDetails(),
      androidAllowWhileIdle: true,
    );
  }
}
