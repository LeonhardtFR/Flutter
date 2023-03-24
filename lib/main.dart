import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:osbrosound/ButtonNavigation.dart';
import 'package:osbrosound/Screens/Library/library.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'OsbroSound',
      debugShowCheckedModeBanner: false,
      home: ButtonNavigation(),
    );
  }
}

