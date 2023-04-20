import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Controllers/radioPlayerController.dart';
import 'dart:convert';

class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key}) : super(key: key);

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final TextEditingController controllerUrl = TextEditingController(
      text: 'https://listen.radioking.com/radio/242578/stream/286663');

  final RadioAudioController radioAudioController = Get.put(RadioAudioController());
  PlayerController playerController = Get.find<PlayerController>();

  final StreamController<Map<String, dynamic>> _metadataController =
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
  }

  void _startMetadataUpdates() {
    Duration refreshMetadata;
    refreshMetadata = const Duration(seconds: 5);

    Timer.periodic(refreshMetadata, (timer) async {
      try {
        final newMetadata = await getCurrentTrackMetadata();
        if (_previousMetadata['title'] != newMetadata['title']) {
          _previousMetadata = newMetadata;
          _metadataController.add(newMetadata);
        }
      } catch (e) {
        if (kDebugMode) {
          print("Erreur lors de la récupération des métadonnées : $e");
        }
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
        'album': jsonResponse['album'] ?? 'Unknown',
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
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        appBar: AppBar(
          title: Text('Radio', style: TextStyle(color: Theme
            .of(context)
            .textTheme
            .bodyLarge!
            .color)),
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .background,
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: controllerUrl,
            decoration: InputDecoration(
              hintText: 'Enter a radio api',
              hintStyle: TextStyle(color:
              Theme.of(context).colorScheme.onBackground),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).unselectedWidgetColor,
                ),
              ),
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        const SizedBox(height: 16),

      Obx(
            () => IconButton(
        onPressed: () async {
        radioAudioController.isPlaying.value = !radioAudioController.isPlaying.value;
      if (radioAudioController.isPlaying.value) {
        playerController.stopPlayer();
        _startMetadataUpdates();
        await radioAudioController.playRadio(controllerUrl.text);
      } else {
        radioAudioController.stopRadio();
      }
        },
          icon: radioAudioController.isPlaying.value
              ? Icon(Icons.pause,
              color: Theme.of(context).colorScheme.onBackground, size: 36)
              : Icon(Icons.play_arrow,
              color: Theme.of(context).colorScheme.onBackground, size: 36),
        ),
      ),

                const SizedBox(height: 16),
                StreamBuilder<Map<String, dynamic>>(
                  stream: _metadataController.stream,
                  initialData: _previousMetadata,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    final metadata = snapshot.data;
                    return metadata!['title'] != ""
                        ? Column(
                      children: [
                        Text(
                          'Title : ${metadata['title']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Artist : ${metadata['artist']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Album : ${metadata['album']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 16),
                        metadata['cover'] != ""
                            ? Image.network(
                          metadata['cover'],
                          width: 250,
                          height: 250,
                        )
                            : const SizedBox(),
                      ],
                    )
                        : const SizedBox();
                  },
                ),
              ],
          ),
        ),
    );
  }
}

