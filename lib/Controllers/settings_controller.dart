import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/Library/library.dart';
import 'libraryController.dart';

class SettingsController extends GetxController {
  var amoledMode = false.obs;

  // 0 -> Light, 1 -> Dark, 2 -> AMOLED
  final themeMode = 0.obs;

  var songSelectedDirectory = "".obs;

  Future<void> saveTheme(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', value);
  }

  Future<int> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('themeMode') ?? 0;
  }

  Future<void> saveSongFolder(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentSongFolder', value);
  }

  Future<String> loadSongFolder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentSongFolder') ?? "";
  }

  Future<void> getFolderSongs() async {
    final libraryController = Get.put(LibraryController());
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: "Select a folder",
        initialDirectory: "/storage/emulated/0/Music");
    if (selectedDirectory != null) {
      await saveSongFolder(selectedDirectory);
      songSelectedDirectory.value =
          selectedDirectory; // on maj la valeur choisi
      libraryController.getMusic();
    } else {
      print("No folder selected");
    }
  }
}
