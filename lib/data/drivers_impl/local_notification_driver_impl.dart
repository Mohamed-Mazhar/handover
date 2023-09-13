import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:handover/data/drivers/local_notification_driver.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "handover", // id
  'MY FOREGROUND SERVICE', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high, // importance must be at low or higher level
);

class LocalNotificationDriverImpl extends LocalNotificationDriver {

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  LocalNotificationDriverImpl({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  }) : _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin;


  @override
  Future<void> showNotification({
    required int notificationId,
    required String title,
    required String message,
  }) async {
    debugPrint("Showing notification $title $message");
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "handover",
          "Handover Notifications",
          priority: Priority.high,
          icon: 'ic_bg_service_small',
          styleInformation: BigTextStyleInformation(''),
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  @override
  Future<void> cancelNotification({required int notificationId}) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }


}
