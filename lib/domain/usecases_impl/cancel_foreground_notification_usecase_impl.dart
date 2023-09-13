import 'package:handover/data/drivers/local_notification_driver.dart';
import 'package:handover/domain/usecases/cancel_foreground_notification_usecase.dart';

class CancelForegroundNotificationUsecaseImpl extends CancelForegroundNotificationUsecase {
  final LocalNotificationDriver _localNotificationDriverImpl;

  CancelForegroundNotificationUsecaseImpl({
    required LocalNotificationDriver localNotificationDriverImpl,
  }): _localNotificationDriverImpl = localNotificationDriverImpl;

  @override
  Future<void> cancel({required int notificationId}) async{
    return _localNotificationDriverImpl.cancelNotification(notificationId: notificationId);
  }
}
