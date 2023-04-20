/*
 * Copyright (c) 2023-2024, Maxime BÉZIAT (OsbroTechnologies™ - OsbroSound)
*/


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logger/logger.dart';
import 'package:osbrosound/ButtonNavigation.dart';
import 'package:osbrosound/Controllers/radioPlayerController.dart';
import 'package:osbrosound/Controllers/settings_controller.dart';
import 'package:osbrosound/Widgets/welcome.dart';
import 'package:osbrosound/app_initialize.dart';
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
  settingsController.songSelectedDirectory.value =
      await settingsController.loadSongFolder();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  var logger = Logger(
    printer: PrettyPrinter(methodCount: 0, lineLength: 1),
  );

  SettingsController settingsController = Get.put(SettingsController());
  RadioAudioController radioAudioController = Get.put(RadioAudioController());
  PlayerController playerController = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    final AppInitializer appInitializer = AppInitializer(settingsController, logger);
    appInitializer.checkFirstLaunch();
    return Obx(() => GetMaterialApp(
          title: 'OsbroSound',
          theme: lightAppThemeData,
          darkTheme: settingsController.themeMode.value == 1
              ? darkAppThemeData
              : amoledAppThemeData,
          themeMode: settingsController.themeMode.value == 0
              ? ThemeMode.light
              : ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [GetObserver()],
          // home: const ButtonNavigation(),
      home: Stack(
        children: [
          const ButtonNavigation(),
          if (settingsController.firstLaunch.value)
          const WelcomeWidget(),
        ],
      ),
    ));
  }
}