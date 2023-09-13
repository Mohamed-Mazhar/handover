import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handover/domain/usecases/get_points_between_src_and_dst_usecase.dart';

class GetPointsBetweenSrcAndDstUsecaseImpl extends GetPointsBetweenSrcAndDstUsecase {
  final PolylinePoints _points;

  GetPointsBetweenSrcAndDstUsecaseImpl({
    required PolylinePoints polylinePoints,
  }) : _points = polylinePoints;

  @override
  Future<List<LatLng>> get({
    required LatLng source,
    required LatLng destination,
  }) async {
    List<LatLng> routePoints = [];
    PolylineResult result = await _points.getRouteBetweenCoordinates(
      'AIzaSyANhZSt0jJRcKJ2bl5ws_wMLF9krPQS6bA',
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var element in result.points) {
        routePoints.add(LatLng(element.latitude, element.longitude));
      }
    }
    return routePoints;
  }
}
