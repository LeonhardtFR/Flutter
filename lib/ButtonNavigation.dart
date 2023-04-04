import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:osbrosound/Screens/Radio/radio.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'Controllers/playerController.dart';
import 'Screens/Library/library.dart';
import 'Screens/Settings/Settings.dart';
import 'Screens/Youtube/YoutubeHome.dart';

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({Key? key}) : super(key: key);

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {
  PlayerController playerController = Get.find<PlayerController>();
  List<Widget> _NavScreens() {
    return [
      const LibraryPage(),
      const YoutubeHomeScreen(),
      const RadioScreen(),
      const SettingsScreen(),
    ];
  }

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.library_music),
        // title: ("Library"),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.youtube_searched_for),
        // title: ("Youtube"),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings_input_antenna),
        // title: ("Radio"),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        // title: ("Settings"),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  int selectedIndex = 0;

  final List _pages = [
    const LibraryPage(),
    const YoutubeHomeScreen(),
    const RadioScreen(),
    const SettingsScreen(),
  ];

  // @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        onItemSelected: (index) {
          print("Selected item index: $index");
        },
        context,
        controller: _controller,
        screens: _NavScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Color(0xFF131313),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style6,
        navBarHeight: 39,
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      ),
    );
  }
}
