import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handover/dependencies/blocs/map_screen_bloc_provider.dart';
import 'package:handover/handover_background_services.dart';
import 'package:handover/presentation/blocs/map_screen_bloc/map_screen_bloc.dart';
import 'package:handover/presentation/screens/delivery_completed_action_sheet.dart';
import 'package:handover/presentation/screens/track_delivery_action_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return _MapPage();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        FlutterBackgroundService().invoke("setAsBackground");
        debugPrint("app in resumed");
        break;
      case AppLifecycleState.inactive:
        debugPrint("app in inactive");
        break;
      case AppLifecycleState.paused:
        await initializeService();
        FlutterBackgroundService().invoke("setAsForeground");
        debugPrint("app in paused");
        break;
      case AppLifecycleState.detached:
        debugPrint("app in detached");
        break;
      case AppLifecycleState.hidden:
        debugPrint("app in hidden");
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}

class _MapPage extends StatelessWidget {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapScreenBloc>(
      create: (context) => MapScreenBlocProvider.get()..add(MapScreenLaunchedEvent()),
      child: BlocBuilder<MapScreenBloc, MapScreenState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<MapScreenBloc>(context);
          final stateHolder = bloc.state.stateHolder;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ),
            body: stateHolder.routePoints.isEmpty || stateHolder.currentPosition == null
                ? const Center(child: Text('loading position'))
                : Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: stateHolder.currentPosition!,
                          zoom: 12,
                        ),
                        // polylines: {
                        //   Polyline(
                        //     polylineId: const PolylineId("routes"),
                        //     points: routePoints,
                        //     color: Colors.deepOrange,
                        //     width: 5,
                        //   )
                        // },
                        markers: {
                          Marker(
                            icon: stateHolder.currentLocationIcon,
                            markerId: const MarkerId("currentPosition"),
                            position: stateHolder.currentPosition!,
                          ),
                          // Marker(
                          //   icon: sourceIcon,
                          //   markerId: const MarkerId("source"),
                          //   position: source,
                          // ),
                          // Marker(
                          //   icon: destinationIcon,
                          //   markerId: const MarkerId("destination"),
                          //   position: endDest,
                          // )
                        },
                        onMapCreated: (mapController) {
                          _controller.complete(mapController);
                        },
                        circles: {
                          Circle(
                            circleId: const CircleId("source"),
                            center: stateHolder.source,
                            radius: 1000,
                            fillColor: const Color.fromRGBO(208, 222, 246, 0.7),
                            strokeWidth: 0,
                          ),
                          Circle(
                            circleId: const CircleId("source"),
                            center: stateHolder.source,
                            radius: 300,
                            fillColor: const Color.fromRGBO(146, 184, 253, 0.7),
                            strokeWidth: 0,
                          ),
                          Circle(
                            circleId: const CircleId("source"),
                            center: stateHolder.source,
                            radius: 150,
                            fillColor: const Color.fromRGBO(56, 126, 252, 1),
                            strokeWidth: 0,
                          ),
                          Circle(
                            circleId: const CircleId("dest"),
                            center: stateHolder.destination,
                            radius: 1000,
                            fillColor: const Color.fromRGBO(219, 237, 241, 0.7),
                            strokeWidth: 0,
                          ),
                          Circle(
                            circleId: const CircleId("dest"),
                            center: stateHolder.destination,
                            radius: 300,
                            fillColor: const Color.fromRGBO(146, 222, 233, 0.7),
                            strokeWidth: 0,
                          ),
                          Circle(
                            circleId: const CircleId("dest"),
                            center: stateHolder.destination,
                            radius: 150,
                            fillColor: const Color.fromRGBO(56, 194, 218, 1),
                            strokeWidth: 0,
                          ),
                        },
                      ),
                      bloc.state is! MapScreenPackageDeliveryCompletedState
                          ? TrackDeliveryActionSheet(stateHolder: stateHolder)
                          : DeliveryCompletedActionSheet(
                              pickUpTime: stateHolder.pickupTime!,
                              deliveryTime: stateHolder.deliveryTime!,
                            ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
