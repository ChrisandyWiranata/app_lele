import 'package:app_lele/components/app_colors.dart';
import 'package:app_lele/screen/splash.dart';
import 'package:app_lele/service/notification_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeLocationPermission();

  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeRemoteNotifications(debug: true);
  await NotificationController.startListeningNotificationEvents();

  runApp(const MyApp());
}

Future<void> initializeLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
}

Future<void> initializeNotification() async {
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.light(
          primary: AppColors.curelean,
          secondary: AppColors.bluetopaz,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
