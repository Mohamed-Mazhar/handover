import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:handover/domain/usecases/get_points_between_src_and_dst_usecase.dart';
import 'package:handover/domain/usecases_impl/get_points_between_src_and_dst_usecase_impl.dart';

class GetPointsBetweenSrcAndDstUsecaseProvider {
  GetPointsBetweenSrcAndDstUsecaseProvider._();

  static GetPointsBetweenSrcAndDstUsecase get() {
    return GetPointsBetweenSrcAndDstUsecaseImpl(polylinePoints: PolylinePoints());
  }
}