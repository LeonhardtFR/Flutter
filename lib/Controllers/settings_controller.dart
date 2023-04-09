import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  var amoledMode = false.obs;

  // 0 -> Light, 1 -> Dark, 2 -> AMOLED
  final themeMode = 0.obs;

  Future<void> saveTheme(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', value);
  }

  Future<int> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('themeMode') ?? 0;
  }
}