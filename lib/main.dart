import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:osbrosound/ButtonNavigation.dart';
import 'package:osbrosound/Services/service_locator.dart';

void main() async {
  await setupServiceLocator();
  runApp(const MyApp());
}

// late AudioHandler _audioHandler;
//
// Future<void> main() async {
//   _audioHandler = await AudioService.init(
//     builder: () => BackgroundAudio(),
//     config: const AudioServiceConfig(
//       androidNotificationChannelId: 'com.osbro.osbrosound',
//       androidNotificationChannelName: 'OsbroSound',
//       androidNotificationIcon: 'mipmap/ic_launcher',
//       androidStopForegroundOnPause: true,
//       androidResumeOnClick: true,
//       androidShowNotificationBadge: true,
//       androidNotificationOngoing: true,
//     ),
//   );
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'OsbroSound',
      debugShowCheckedModeBanner: false,
      home: ButtonNavigation(),
    );
  }
}