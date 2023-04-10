import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:osbrosound/AudioManager.dart';
import 'package:osbrosound/ButtonNavigation.dart';
import 'package:osbrosound/Controllers/radioPlayerController.dart';
import 'package:osbrosound/Controllers/settings_controller.dart';
import 'package:osbrosound/Services/service_locator.dart';
import 'package:osbrosound/themes/theme_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Controllers/playerController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Notification
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'OsbroSound',
    androidNotificationOngoing: true,
  );
  SettingsController settingsController = Get.put(SettingsController());
  settingsController.themeMode.value = await settingsController.loadTheme();
  settingsController.songSelectedDirectory.value = await settingsController.loadSongFolder();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  SettingsController settingsController = Get.put(SettingsController());
  RadioAudioController radioAudioController = Get.put(RadioAudioController());
  PlayerController playerController = Get.put(PlayerController());
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      title: 'OsbroSound',
      theme: lightAppThemeData,
      darkTheme: settingsController.themeMode.value == 1 ? darkAppThemeData : amoledAppThemeData,
      themeMode: settingsController.themeMode.value == 0 ? ThemeMode.light : ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [GetObserver()],
      home: const ButtonNavigation(),
    )
    );
  }
}