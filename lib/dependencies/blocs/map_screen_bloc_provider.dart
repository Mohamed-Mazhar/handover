import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:handover/dependencies/usecases/get_points_between_src_and_dst_usecase_provider.dart';
import 'package:handover/dependencies/usecases/show_delivery_status_notification_usecase_provider.dart';
import 'package:handover/presentation/blocs/map_screen_bloc/map_screen_bloc.dart';

class MapScreenBlocProvider {
  MapScreenBlocProvider._();

  static MapScreenBloc get() {
    return MapScreenBloc(
      getPointsBetweenSrcAndDstUsecaseImpl: GetPointsBetweenSrcAndDstUsecaseProvider.get(),
      showDeliveryStatusNotificationUsecase: ShowDeliveryStatusNotificationUsecaseProvider.get(),
      flutterBackgroundService: FlutterBackgroundService(),
    );
  }
}
