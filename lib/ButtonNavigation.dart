import 'package:flutter/material.dart';
import 'Screens/Library/library.dart';
import 'Screens/Settings/Settings.dart';
import 'Screens/Youtube/YoutubeHome.dart';

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({Key? key}) : super(key: key);

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {
  int selectedIndex = 0;

  final List _pages = [
    const LibraryPage(),
    const YoutubeHomeScreen(),
    const SettingsScreen()
  ];

  changeScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(
              icon: Icon(Icons.youtube_searched_for), label: 'Youtube'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[900],
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
        backgroundColor: Colors.black,
        onTap: (int index) => changeScreen(index),
      ),
    );
  }
}
