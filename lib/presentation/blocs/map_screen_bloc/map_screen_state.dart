part of 'map_screen_bloc.dart';

abstract class MapScreenState extends Equatable {
  final MapScreenStateHolder stateHolder;

  const MapScreenState(this.stateHolder);

  @override
  List<Object> get props => [stateHolder];

  MapScreenState copyWith({MapScreenStateHolder? stateHolder});
}

class MapScreenInitialState extends MapScreenState {
  const MapScreenInitialState({
    required MapScreenStateHolder mapScreenStateHolder,
  }) : super(mapScreenStateHolder);

  @override
  MapScreenState copyWith({MapScreenStateHolder? stateHolder}) {
    return MapScreenInitialState(mapScreenStateHolder: stateHolder ?? this.stateHolder);
  }
}

class MapScreenUpdateDeliveryLocationState extends MapScreenState {
  const MapScreenUpdateDeliveryLocationState({
    required MapScreenStateHolder stateHolder,
  }) : super(stateHolder);

  @override
  MapScreenState copyWith({MapScreenStateHolder? stateHolder}) {
    return MapScreenUpdateDeliveryLocationState(
      stateHolder: stateHolder ?? this.stateHolder,
    );
  }
}

class MapScreenPackageDeliveryCompletedState extends MapScreenState {
  const MapScreenPackageDeliveryCompletedState({
    required MapScreenStateHolder stateHolder,
  }) : super(stateHolder);

  @override
  MapScreenState copyWith({MapScreenStateHolder? stateHolder}) {
    return MapScreenPackageDeliveryCompletedState(
      stateHolder: stateHolder ?? this.stateHolder,
    );
  }
}
