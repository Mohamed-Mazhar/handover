abstract class ShowDeliveryStatusNotificationUsecase {
  Future<void> show({
    required int notificationId,
    required String title,
    required String message,
  });
}
