import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:osbrosound/AudioManager.dart';
import 'package:osbrosound/ButtonNavigation.dart';
import 'package:osbrosound/Controllers/radioPlayerController.dart';
import 'package:osbrosound/Services/service_locator.dart';
import 'Controllers/playerController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Notification
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'OsbroSound',
    androidNotificationOngoing: true,
  );
  var radioController = Get.put(RadioAudioController());
  var libraryController = Get.put(PlayerController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OsbroSound',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [GetObserver()],
      home: const ButtonNavigation(),
    );
  }
}
