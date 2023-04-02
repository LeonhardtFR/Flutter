import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class radioScreen extends StatefulWidget {
  const radioScreen({Key? key}) : super(key: key);

  @override
  State<radioScreen> createState() => _radioScreenState();
}

class _radioScreenState extends State<radioScreen> {
  final TextEditingController controllerUrl = TextEditingController(text: 'https://api.radioking.io/widget/radio/bankable-radio/track/current');
  static const url = 'https://listen.radioking.com/radio/242578/stream/286663';

  late AudioPlayer radioPlayer;
  bool _isPlaying = false;

  StreamController<Map<String, dynamic>> _metadataController = StreamController<Map<String, dynamic>>.broadcast();

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    getCurrentTrackMetadata();
  }

  void _startMetadataUpdates() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final newMetadata = await getCurrentTrackMetadata();
        _metadataController.add(newMetadata);
      } catch (e) {
        print("Erreur lors de la récupération des métadonnées : $e");
      }
    });
  }


  // Recuperation des données de la radio (titres, artistes, etc)
  Future getCurrentTrackMetadata() async {
    final response = await http.get(Uri.parse('https://api.radioking.io/widget/radio/bankable-radio/track/current'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      try {
        final metadata = await jsonResponse;
        final trackTitle = metadata['title'];
        final trackArtist = metadata['artist'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Titre: $trackTitle - Artiste: $trackArtist'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la récupération des métadonnées'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la récupération des métadonnées'),
        ),
      );
    }
  }





  _initAudioPlayer() {
    radioPlayer = AudioPlayer();
    radioPlayer.setUrl(url);

    final mediaItem = MediaItem(
            id: url,
            title: "Radio Stream",
    );

    radioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url),
        tag: mediaItem));

    _startMetadataUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
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

                        if (_isPlaying) {
                          radioPlayer.play();
                        } else {
                          radioPlayer.pause();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





