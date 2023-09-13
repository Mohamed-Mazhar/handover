import 'package:handover/data/drivers/local_notification_driver.dart';
import 'package:handover/domain/usecases/show_delivery_status_notification_usecase.dart';

class ShowDeliveryStatusNotificationUsecaseImpl extends ShowDeliveryStatusNotificationUsecase {
  final LocalNotificationDriver _localNotificationDriverImpl;

  ShowDeliveryStatusNotificationUsecaseImpl({
    required LocalNotificationDriver localNotificationDriverImpl,
  }) : _localNotificationDriverImpl = localNotificationDriverImpl;

  @override
  Future<void> show({
    required int notificationId,
    required String title,
    required String message,
  }) {
    return _localNotificationDriverImpl.showNotification(
      title: title,
      message: message,
      notificationId: notificationId,
    );
  }
}
