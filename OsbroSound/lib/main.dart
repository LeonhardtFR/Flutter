import 'package:flutter/material.dart';
import 'package:osbrosound/Screens/Library/library.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'OsbroSound',
      home: LibraryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

