import 'package:flutter/material.dart';
import 'package:tuto1/screens/homeScreen.dart';

import 'ButtonNavigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accueil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ButtonNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
