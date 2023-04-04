import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Controllers/playerController.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key}) : super(key: key);

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final TextEditingController controllerUrl = TextEditingController(
      text:
          'https://api.radioking.io/widget/radio/bankable-radio/track/current');
  static const url = 'https://listen.radioking.com/radio/242578/stream/286663';

  PlayerController radioPlayer = Get.find<PlayerController>();
  bool _isPlaying = false;

  StreamController<Map<String, dynamic>> _metadataController =
      StreamController<Map<String, dynamic>>.broadcast();

  Map<String, dynamic> _previousMetadata = {'title': '', 'artist': ''};

  @override
  void initState() {
    super.initState();
  }

  void _startMetadataUpdates() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final newMetadata = await getCurrentTrackMetadata();

        if (_previousMetadata['title'] != newMetadata['title']) {
          _previousMetadata = newMetadata;
          _metadataController.add(newMetadata);
          showSnackbar(newMetadata);
        }
      } catch (e) {
        print("Erreur lors de la récupération des métadonnées : $e");
      }
    });
  }

  Future<Map<String, dynamic>> getCurrentTrackMetadata() async {
    final response = await http.get(Uri.parse(
        'https://api.radioking.io/widget/radio/bankable-radio/track/current'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final metadata = {
        'title': jsonResponse['title'],
        'artist': jsonResponse['artist'],
      };
      return metadata;
    } else {
      throw Exception('Erreur lors de la récupération des métadonnées');
    }
  }

  _initAudioPlayer() {
    radioPlayer.audioPlayer.setUrl(url);
    final mediaItem = MediaItem(id: url, title: "Radio Stream");
    radioPlayer.audioPlayer
        .setAudioSource(AudioSource.uri(Uri.parse(url), tag: mediaItem));
  }

  void showSnackbar(Map<String, dynamic> metadata) {
    final trackTitle = metadata['title'];
    final trackArtist = metadata['artist'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Titre: $trackTitle - Artiste: $trackArtist'),
      ),
    );
  }

  @override
  void dispose() {
    _metadataController.close();
    // radioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Radio'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controllerUrl,
                decoration: const InputDecoration(
                  hintText: 'Enter a radio api',
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
              child: const Text('Lire'),
              onPressed: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });

                _initAudioPlayer();
                if (_isPlaying) {
                  _initAudioPlayer();
                  _startMetadataUpdates();
                  radioPlayer.audioPlayer.play();
                } else {
                  radioPlayer.audioPlayer.pause();
                }
                print(_isPlaying);
              },
            ),
          ],
        ),
      ),
    );
  }
}
