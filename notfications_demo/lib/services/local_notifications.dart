import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class localNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    _flutterLocalNotificationsPlugin.initialize(initializationSettingsAndroid,
        onSelectNotification: (String? payload) {
      print(payload);
    });
  }

  static void showNotificationOnForeground(RemoteMessage message) {
    _flutterLocalNotificationsPlugin.show(
        DateTime.now().microsecond,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'com.example.notfications_demo', 'channel_name',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker',
                autoCancel: true)),
        payload: message.data["Comida"]);
  }
}
