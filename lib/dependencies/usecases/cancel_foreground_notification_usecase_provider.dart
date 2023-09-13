import 'package:handover/dependencies/drivers/local_notification_driver_provider.dart';
import 'package:handover/domain/usecases_impl/cancel_foreground_notification_usecase_impl.dart';

class CancelForegroundNotificationUsecaseProvider {
  CancelForegroundNotificationUsecaseProvider._();

  static CancelForegroundNotificationUsecaseImpl get() {
    return CancelForegroundNotificationUsecaseImpl(
      localNotificationDriverImpl: LocalNotificationDriverProvider.get(),
    );
  }
}
