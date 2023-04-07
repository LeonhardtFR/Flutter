import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('OsbroSound Settings',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Text(
              'Folder selection : ',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 16),
            Text('Enable dark theme : ',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
