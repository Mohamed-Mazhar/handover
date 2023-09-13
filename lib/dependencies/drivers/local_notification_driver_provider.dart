import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:handover/data/drivers/local_notification_driver.dart';
import 'package:handover/data/drivers_impl/local_notification_driver_impl.dart';

class LocalNotificationDriverProvider {
  LocalNotificationDriverProvider._();

  static LocalNotificationDriver get() {
    return LocalNotificationDriverImpl(
      flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
    );
  }
}
