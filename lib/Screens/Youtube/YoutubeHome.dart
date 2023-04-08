import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:osbrosound/Controllers/youtubeController.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeHomeScreen extends StatefulWidget {
  const YoutubeHomeScreen({Key? key}) : super(key: key);

  @override
  State<YoutubeHomeScreen> createState() => _YoutubeHomeScreenState();
}

class _YoutubeHomeScreenState extends State<YoutubeHomeScreen> {
  final YoutubeController youtubeController = Get.put(YoutubeController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text('Youtube Search'),
              backgroundColor: Colors.black,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: youtubeController.controllerYtbUrl,
                      decoration: const InputDecoration(
                        hintText: 'Paste Youtube URL music',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text('Télécharger'),
                    onPressed: () {
                      youtubeController.getAudio();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
