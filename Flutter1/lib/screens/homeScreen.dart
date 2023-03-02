import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(image: AssetImage("assets/images/ynov.jpg"), width: 150),
            Text('Accueil', style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)),
            Text('Bienvenue sur l\'accueil', style: TextStyle(fontSize: 20, color: Colors.deepOrange, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
