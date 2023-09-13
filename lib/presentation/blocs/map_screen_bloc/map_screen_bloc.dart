import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handover/domain/usecases/get_points_between_src_and_dst_usecase.dart';
import 'package:handover/domain/usecases/show_delivery_status_notification_usecase.dart';

part 'map_screen_event.dart';

part 'map_screen_state.dart';

part 'map_screen_state_holder.dart';

class MapScreenBloc extends Bloc<MapScreenEvent, MapScreenState> {
  final GetPointsBetweenSrcAndDstUsecase _getPointsBetweenSrcAndDstUsecaseImpl;
  final ShowDeliveryStatusNotificationUsecase _showDeliveryStatusNotificationUsecaseImpl;
  final FlutterBackgroundService _flutterBackgroundService;

  static const fiveKilometers = 5;
  static const oneHundredMeters = 0.1;
  static const notificationId = 4554;

  MapScreenBloc({
    required GetPointsBetweenSrcAndDstUsecase getPointsBetweenSrcAndDstUsecaseImpl,
    required ShowDeliveryStatusNotificationUsecase showDeliveryStatusNotificationUsecase,
    required FlutterBackgroundService flutterBackgroundService,
  })  : _getPointsBetweenSrcAndDstUsecaseImpl = getPointsBetweenSrcAndDstUsecaseImpl,
        _showDeliveryStatusNotificationUsecaseImpl = showDeliveryStatusNotificationUsecase,
        _flutterBackgroundService = flutterBackgroundService,
        super(
          const MapScreenInitialState(
            mapScreenStateHolder: MapScreenStateHolder(
              currentPosition: null,
            ),
          ),
        ) {
    on<MapScreenEvent>((event, emit) async {
      await _mapScreenEventToState(event: event, emit: emit);
    });
  }

  Future<void> _mapScreenEventToState({
    required MapScreenEvent event,
    required Emitter<MapScreenState> emit,
  }) async {
    if (event is MapScreenLaunchedEvent) {
      await _mapScreenLaunchedEventToState(event: event, emit: emit);
    } else if (event is MapScreenListenForLocationChangedEvent) {
      await _mapLocationChangedEventToState(event: event, emit: emit);
    }
  }

  Future<void> _mapScreenLaunchedEventToState({
    required MapScreenLaunchedEvent event,
    required Emitter<MapScreenState> emit,
  }) async {
    const LatLng source = LatLng(30.054535, 31.291564);
    const LatLng destination = LatLng(30.117705, 31.349860);

    final points = await _getPointsBetweenSrcAndDstUsecaseImpl.get(
      source: source,
      destination: destination,
    );
    final currentPosition = points[points.length ~/ 2];
    final currentLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "assets/source_marker.png",
    );
    emit(
      MapScreenInitialState(
        mapScreenStateHolder: state.stateHolder.copyWith(
          routePoints: points,
          currentPosition: currentPosition,
          currentLocationIcon: currentLocationIcon,
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    add(MapScreenListenForLocationChangedEvent());
  }

  Future<void> _mapLocationChangedEventToState({
    required MapScreenListenForLocationChangedEvent event,
    required Emitter<MapScreenState> emit,
  }) async {
    await _simulateMovementToPickUpPackage(emit: emit);
    emit(
      MapScreenUpdateDeliveryLocationState(
        stateHolder: state.stateHolder.copyWith(
          pickedUpDelivery: true,
        ),
      ),
    );
    await _simulateMovementToDeliverPackage(emit: emit);
    emit(
      MapScreenUpdateDeliveryLocationState(
        stateHolder: state.stateHolder.copyWith(deliveredPackage: true),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    _flutterBackgroundService.invoke("stopService");
    await _showDeliveryStatusNotificationUsecaseImpl.show(
      notificationId: notificationId,
      title: 'Package delivered',
      message: 'Please rate your experience.',
    );
    emit(MapScreenPackageDeliveryCompletedState(stateHolder: state.stateHolder));
  }

  Future<void> _simulateMovementToPickUpPackage({
    required Emitter<MapScreenState> emit,
  }) async {
    LatLng currentPosition = state.stateHolder.currentPosition!;
    final routePoints = state.stateHolder.routePoints;
    bool showPushFor5KMPickUp = true;
    bool showPushFor100MetersPickUp = true;
    for (int z = routePoints.length ~/ 2; z >= 0; z--) {
      currentPosition = routePoints[z];
      final distanceFromPickUpPoint = _calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        state.stateHolder.source.latitude,
        state.stateHolder.source.longitude,
      );
      if (distanceFromPickUpPoint <= fiveKilometers && showPushFor5KMPickUp) {
        await _showDeliveryStatusNotificationUsecaseImpl.show(
          notificationId: notificationId,
          title: 'Passed 5KM Range',
          message: 'The carrier has passed the 5KM range.',
        );
        showPushFor5KMPickUp = false;
      } else if (distanceFromPickUpPoint <= oneHundredMeters && showPushFor100MetersPickUp) {
        await _showDeliveryStatusNotificationUsecaseImpl.show(
          notificationId: notificationId,
          title: 'Will Arrive Shortly',
          message: 'The carrier will arrive shortly and pick up the package',
        );
        showPushFor100MetersPickUp = false;
      }
      emit(
        MapScreenUpdateDeliveryLocationState(
          stateHolder: state.stateHolder.copyWith(
            currentPosition: currentPosition,
            pickupTime: DateTime.now(),
          ),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _simulateMovementToDeliverPackage({
    required Emitter<MapScreenState> emit,
  }) async {
    LatLng currentPosition = state.stateHolder.currentPosition!;
    final routePoints = state.stateHolder.routePoints;
    bool showPushFor5KMPickUp = true;
    bool showPushFor100MetersPickUp = true;
    for (int i = 0; i < routePoints.length - 1; i++) {
      currentPosition = routePoints[i];
      final distanceFromDeliveryPoint = _calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        state.stateHolder.destination.latitude,
        state.stateHolder.destination.longitude,
      );
      if (distanceFromDeliveryPoint <= fiveKilometers && showPushFor5KMPickUp) {
        await _showDeliveryStatusNotificationUsecaseImpl.show(
          notificationId: notificationId,
          title: 'Within 5KM',
          message: 'The carrier will arrive to the delivery destination',
        );
        showPushFor5KMPickUp = false;
        emit(
          MapScreenUpdateDeliveryLocationState(
            stateHolder: state.stateHolder.copyWith(
              currentPosition: routePoints[i],
              nearDeliveryDest: true,
            ),
          ),
        );
      } else if (distanceFromDeliveryPoint <= oneHundredMeters && showPushFor100MetersPickUp) {
        await _showDeliveryStatusNotificationUsecaseImpl.show(
          notificationId: 4554,
          title: 'Will Arrive within minutes',
          message: 'The carrier will arrive within minutes to deliver the package.',
        );
        showPushFor100MetersPickUp = false;
        emit(
          MapScreenUpdateDeliveryLocationState(
            stateHolder: state.stateHolder.copyWith(
              nearDeliveryDest: true,
              currentPosition: routePoints[i],
              deliveryTime: DateTime.now(),
            ),
          ),
        );
      }
      emit(
        MapScreenUpdateDeliveryLocationState(
          stateHolder: state.stateHolder.copyWith(
            currentPosition: routePoints[i],
          ),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
