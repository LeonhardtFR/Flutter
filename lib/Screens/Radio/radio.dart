import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:osbrosound/Controllers/radioPlayerController.dart';
import 'dart:convert';


class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key}) : super(key: key);

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final TextEditingController controllerUrl = TextEditingController(
      text: 'https://api.radioking.io/widget/radio/bankable-radio/track/current');
  static const url = 'https://listen.radioking.com/radio/242578/stream/286663';

  final RadioAudioController radioAudioController = Get.put(RadioAudioController());
  bool _isPlaying = false;

  StreamController<Map<String, dynamic>> _metadataController =
  StreamController<Map<String, dynamic>>.broadcast();

  Map<String, dynamic> _previousMetadata = {
    'title': '',
    'artist': '',
    'album': '',
    'cover': ''
  };

  @override
  void initState() {
    super.initState();
    // _startMetadataUpdates();
  }

  void _startMetadataUpdates() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final newMetadata = await getCurrentTrackMetadata();

        if (_previousMetadata['title'] != newMetadata['title']) {
          _previousMetadata = newMetadata;
          _metadataController.add(newMetadata);
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
        'album': jsonResponse['album'] != null
            ? jsonResponse['album']
            : 'Unknown',
        'cover': jsonResponse['cover'],
      };
      return metadata;
    } else {
      throw Exception('Erreur lors de la récupération des métadonnées');
    }
  }

  @override
  void dispose() {
    _metadataController.close();
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
              hintStyle: TextStyle(color: Colors.white),
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

      Obx(
            () => IconButton(
        onPressed: () async {
        radioAudioController.isPlaying.value = !radioAudioController.isPlaying.value;
      if (radioAudioController.isPlaying.value) {
        _startMetadataUpdates();
        await radioAudioController.playRadio(url);
      } else {
        radioAudioController.stopRadio();
      }
        },
          icon: radioAudioController.isPlaying.value
              ? const Icon(Icons.pause,
              color: Colors.white, size: 36)
              : const Icon(Icons.play_arrow,
              color: Colors.white, size: 36),
        ),
      ),

                const SizedBox(height: 16),
                StreamBuilder<Map<String, dynamic>>(
                  stream: _metadataController.stream,
                  initialData: _previousMetadata,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    final metadata = snapshot.data;
                    return metadata != null
                        ? Column(
                      children: [
                        Text(
                          'Title : ${metadata['title']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Artist : ${metadata['artist']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Album : ${metadata['album']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 16),
                        metadata['cover'] != null
                            ? Image.network(
                          metadata['cover'],
                          width: 250,
                          height: 250,
                        )
                            : const SizedBox(),
                      ],
                    )
                        : const CircularProgressIndicator();
                  },
                ),
              ],
          ),
        ),
    );
  }
}

