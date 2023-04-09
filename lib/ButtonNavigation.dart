import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Controllers/radioPlayerController.dart';
import 'package:osbrosound/Screens/Radio/radio.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'Screens/Library/library.dart';
import 'Screens/Settings/Settings.dart';
import 'Screens/Youtube/YoutubeHome.dart';

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({Key? key}) : super(key: key);

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {
  RadioAudioController radioAudioController = Get.find<RadioAudioController>();
  PlayerController playerController = Get.find<PlayerController>();
  List<Widget> _NavScreens() {
    return [
      const LibraryPage(),
      const YoutubeHomeScreen(),
      const RadioScreen(),
      SettingsScreen(),
    ];
  }

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.library_music),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.youtube_searched_for),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings_input_antenna),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  void controlTabPlayer(int index) {
    if (index == 0) {
      radioAudioController.isPlaying.value = false;
      radioAudioController.stopRadio();
    } else if (index == 2) {
      playerController.isPlaying.value = false;
      playerController.stopPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        onItemSelected: (index) {
          controlTabPlayer(index);
          if (kDebugMode) {
            print("Selected item index: $index");
          }
        },
        context,
        controller: _controller,
        screens: _NavScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style6,
        navBarHeight: 39,
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
      ),
    );
  }
}
