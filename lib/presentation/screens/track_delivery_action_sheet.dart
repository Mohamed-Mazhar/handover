import 'package:flutter/material.dart';
import 'package:handover/presentation/blocs/map_screen_bloc/map_screen_bloc.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackDeliveryActionSheet extends StatelessWidget {
  final MapScreenStateHolder stateHolder;

  const TrackDeliveryActionSheet({super.key, required this.stateHolder});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.45,
      builder: (builder, controller) {
        return Stack(
          children: [
            Container(
              padding: const EdgeInsetsDirectional.only(start: 16, top: 66),
              margin: const EdgeInsetsDirectional.only(top: 50),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(250, 174, 43, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: _buildDeliveryInfo(context: context),
            ),
            const Align(
              alignment: AlignmentDirectional.topCenter,
              child: Material(
                shape: CircleBorder(side: BorderSide.none),
                elevation: 13,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/current_position_marker.png',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Column _buildDeliveryInfo({
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Mohamed Abdullah",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildDeliveryStatus(
          context: context,
        ),
      ],
    );
  }

  Column _buildDeliveryStatus({
    required BuildContext context,
  }) {
    return Column(
      children: [
        _buildDeliveryTimeLineItem(
          context: context,
          title: "On the way",
          isCompleted: true,
          isFirstItem: true,
          afterLineStyle: LineStyle(
            color: stateHolder.pickedUpDelivery ? Colors.black : Colors.white.withOpacity(0.4),
            thickness: 2,
          ),
        ),
        _buildDeliveryTimeLineItem(
          context: context,
          title: "Picked up delivery",
          isCompleted: stateHolder.pickedUpDelivery,
          isFirstItem: false,
          afterLineStyle: LineStyle(
            color: stateHolder.pickedUpDelivery && stateHolder.nearDeliveryDest
                ? Colors.black
                : Colors.white.withOpacity(0.4),
            thickness: 2,
          ),
        ),
        _buildDeliveryTimeLineItem(
            context: context,
            title: "Near delivery destination",
            isCompleted: stateHolder.nearDeliveryDest,
            isFirstItem: false,
            afterLineStyle: LineStyle(
              color: stateHolder.nearDeliveryDest && stateHolder.deliveredPackage
                  ? Colors.black
                  : Colors.white.withOpacity(0.4),
              thickness: 2,
            )),
        _buildDeliveryTimeLineItem(
          context: context,
          title: "Delivered package",
          isCompleted: stateHolder.deliveredPackage,
          isFirstItem: false,
          afterLineStyle: const LineStyle(
            color: Colors.transparent,
            thickness: 0,
          ),
        ),
      ],
    );
  }

  TimelineTile _buildDeliveryTimeLineItem({
    required BuildContext context,
    required String title,
    required bool isCompleted,
    required bool isFirstItem,
    required LineStyle afterLineStyle,
  }) {
    return TimelineTile(
      isFirst: isFirstItem,
      indicatorStyle: IndicatorStyle(
        width: 10,
        color: isCompleted ? Colors.black : Colors.white.withOpacity(0.8),
      ),
      beforeLineStyle: isFirstItem
          ? const LineStyle(
              color: Colors.transparent,
              thickness: 0,
            )
          : LineStyle(
              color: isCompleted ? Colors.black : Colors.white.withOpacity(0.4),
              thickness: 2,
            ),
      afterLineStyle: afterLineStyle,
      endChild: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsetsDirectional.only(start: 8),
        constraints: const BoxConstraints(
          minHeight: 40,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isCompleted ? Colors.black : Colors.white.withOpacity(0.4),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
