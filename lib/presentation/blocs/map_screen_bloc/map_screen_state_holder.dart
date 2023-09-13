part of 'map_screen_bloc.dart';

class MapScreenStateHolder extends Equatable {
  final LatLng source;
  final LatLng destination;
  final LatLng? currentPosition;
  final bool pickedUpDelivery;
  final bool nearDeliveryDest;
  final bool deliveredPackage;
  final List<LatLng> routePoints;
  final BitmapDescriptor currentLocationIcon;
  final DateTime? pickupTime;
  final DateTime? deliveryTime;

  const MapScreenStateHolder({
    required this.currentPosition,
    this.source = const LatLng(30.054535, 31.291564),
    this.destination = const LatLng(30.117705, 31.349860),
    this.pickedUpDelivery = false,
    this.nearDeliveryDest = false,
    this.deliveredPackage = false,
    this.routePoints = const [],
    this.currentLocationIcon = BitmapDescriptor.defaultMarker,
    this.pickupTime,
    this.deliveryTime,
  });

  MapScreenStateHolder copyWith({
    LatLng? currentPosition,
    LatLng? source,
    LatLng? destination,
    bool? pickedUpDelivery,
    bool? nearDeliveryDest,
    bool? deliveredPackage,
    List<LatLng>? routePoints,
    BitmapDescriptor? currentLocationIcon,
    DateTime? pickupTime,
    DateTime? deliveryTime,
  }) {
    return MapScreenStateHolder(
      currentPosition: currentPosition ?? this.currentPosition,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      deliveredPackage: deliveredPackage ?? this.deliveredPackage,
      nearDeliveryDest: nearDeliveryDest ?? this.nearDeliveryDest,
      pickedUpDelivery: pickedUpDelivery ?? this.pickedUpDelivery,
      routePoints: routePoints ?? this.routePoints,
      currentLocationIcon: currentLocationIcon ?? this.currentLocationIcon,
      pickupTime: pickupTime ?? this.pickupTime,
      deliveryTime: deliveryTime ?? this.deliveryTime,
    );
  }

  @override
  List<Object?> get props => [
        currentPosition,
        source,
        destination,
        pickedUpDelivery,
        nearDeliveryDest,
        deliveredPackage,
        routePoints,
        currentLocationIcon,
        pickupTime,
        deliveryTime,
      ];
}
