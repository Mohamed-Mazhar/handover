abstract class LocalNotificationDriver {
  Future<void> showNotification({
    required int notificationId,
    required String title,
    required String message,
  });

  Future<void> cancelNotification({required int notificationId});
}
