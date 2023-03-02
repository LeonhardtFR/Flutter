import 'package:flutter/material.dart';
import 'package:tuto1/screens/addScreen.dart';
import 'package:tuto1/screens/homeScreen.dart';
import 'package:tuto1/screens/listScreen.dart';

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({Key? key}) : super(key: key);

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {
  int selectedIndex = 0;

  List _pages = [
    homeScreen(),
    listScreen(),
    addScreen(),
  ];

  changeScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const [Text('Accueil'),Text('Liste'),Text('Ajouter')][selectedIndex],
      ),
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Liste',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Ajouter'
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) => changeScreen(index),
      ),
    );
  }
}
