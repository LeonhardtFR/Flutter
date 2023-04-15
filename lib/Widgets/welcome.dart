import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:osbrosound/Controllers/settings_controller.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController = Get.find<SettingsController>();

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Welcome to OsbroSound',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Thank you for using OsbroSound.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20.0),

            const Text(
              'Select a folder where your music is stored, you can change it later in the settings.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10.0),

         ElevatedButton(
              child: const Text('Folder selection'),
              onPressed: () {
                settingsController.getFolderSongs();
                settingsController.saveSongFolder(settingsController.songSelectedDirectory.value);
              },
            ),


        Obx(
              () => Text(settingsController.songSelectedDirectory.value, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color))),

            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Get Started'),
              onPressed: () {
                // Mettez à jour le ValueNotifier pour cacher le WelcomeWidget
                settingsController.firstLaunch.value = false;
              },
            ),
          ],
        ),
      ),
    );
  }
}
