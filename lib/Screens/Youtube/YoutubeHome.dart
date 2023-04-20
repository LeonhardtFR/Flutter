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
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              elevation: 0,
              title: Text('Youtube download',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color)),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: youtubeController.controllerYtbUrl,
                      decoration: InputDecoration(
                        hintText: 'Paste Youtube URL music',
                        hintStyle: TextStyle(
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Télécharger',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground)),
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
