import 'package:flutter/material.dart';
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
  List<Widget> _NavScreens() {
    return [
      const LibraryPage(),
      const YoutubeHomeScreen(),
      const radioScreen(),
      const SettingsScreen(),
    ];
  }

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.library_music),
        title: ("Library"),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.youtube_searched_for),
        title: ("Youtube"),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings_input_antenna),
        title: ("Radio"),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Settings"),
        activeColorPrimary: Colors.amber.shade800,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  int selectedIndex = 0;

  final List _pages = [
    const LibraryPage(),
    const YoutubeHomeScreen(),
    const radioScreen(),
    const SettingsScreen(),
  ];

  changeScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _NavScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.black,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style3,
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: _pages[selectedIndex],
  //     bottomNavigationBar: BottomNavigationBar(
  //       items: const <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.library_music), label: 'Library'),
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.youtube_searched_for), label: 'Youtube'),
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.settings_input_antenna), label: 'Radio'),
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.settings), label: 'Settings'),
  //       ],
  //       currentIndex: selectedIndex,
  //       selectedItemColor: Colors.amber[900],
  //       unselectedItemColor: Colors.grey,
  //       unselectedLabelStyle: const TextStyle(color: Colors.grey),
  //       showUnselectedLabels: true,
  //       backgroundColor: Colors.black,
  //       onTap: (int index) => changeScreen(index),
  //       type: BottomNavigationBarType.fixed,
  //     ),
  //   );
  // }
}
