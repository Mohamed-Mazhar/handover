import 'dart:async';

import 'package:flutter/material.dart';
import 'package:handover/handover_background_services.dart';
import 'package:handover/presentation/screens/map_screen.dart';
import 'package:permission_handler/permission_handler.dart';

const notificationChannelId = 'my_foreground';
const notificationId = 888;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.location.request();
  await Permission.notification.request();
  // await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:  const MapScreen(),
    );
  }
}
