import 'package:handover/dependencies/drivers/local_notification_driver_provider.dart';
import 'package:handover/domain/usecases/show_delivery_status_notification_usecase.dart';
import 'package:handover/domain/usecases_impl/show_delivery_status_notification_usecase_impl.dart';

class ShowDeliveryStatusNotificationUsecaseProvider {
  ShowDeliveryStatusNotificationUsecaseProvider._();

  static ShowDeliveryStatusNotificationUsecase get() {
    return ShowDeliveryStatusNotificationUsecaseImpl(
      localNotificationDriverImpl: LocalNotificationDriverProvider.get(),
    );
  }
}
