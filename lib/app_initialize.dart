import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:osbrosound/Controllers/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInitializer {
  final SettingsController settingsController;
  final Logger logger;

  AppInitializer(this.settingsController, this.logger);

  Future<void> checkFirstLaunch() async {
    logger.i("Checking first launch...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('firstLaunch')) {
      logger.i("First launch detected, setting default values...");
      await prefs.setBool('firstLaunch', false);

      settingsController.themeMode.value = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? ThemeMode.dark.index : ThemeMode.light.index;

      await settingsController.saveTheme(settingsController.themeMode.value);
      settingsController.firstLaunch.value = true;
    } else {
      logger.i("Not first launch, loading values...");
      settingsController.themeMode.value = await settingsController.loadTheme();
      settingsController.firstLaunch.value = false;
    }
  }
}
