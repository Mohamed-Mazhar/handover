import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GetPointsBetweenSrcAndDstUsecase {
  Future<List<LatLng>> get({
    required LatLng source,
    required LatLng destination,
  });
}
