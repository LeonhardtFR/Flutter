import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Screens/Player/MiniPlayer.dart';
import 'package:http/http.dart' as http;

class radioScreen extends StatefulWidget {
  const radioScreen({Key? key}) : super(key: key);

  @override
  State<radioScreen> createState() => _radioScreenState();
}

 const String apiUrl = 'https://api.radioking.io/widget/radio/bankable-radio/track/current';

Future<String> getCurrentTrack(String apiUrl) async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    final track = jsonBody['title'];
    final artist = jsonBody['artist'];
    return '$track - $artist';
  } else {
    throw Exception('Failed to fetch current track');
  }
}

class _radioScreenState extends State<radioScreen> {
  final TextEditingController controller = TextEditingController(text: '');
  List<SongModel> songs = [];
  final OnAudioQuery audioQuery = OnAudioQuery();




  void initState() {
    super.initState();
    // _flutterRadioPlayer.initPlayer();
    getCurrentTrack(apiUrl);
  }

  // Future<void> _getCurrentTrack() async {
  //   try {
  //     final currentTrack = await getCurrentTrack(apiUrl);
  //     setState(() {
  //       songs = [SongModel(title: currentTrack, artist: 'Radio')];
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // final FRPSource frpSource = FRPSource(
  //   mediaSources: <MediaSources>[
  //     MediaSources(
  //         url: "https://api.radioking.io/widget/radio/bankable-radio/track/current", // dummy url
  //         description: "Stream with ICY",
  //         isPrimary: true,
  //         title: "Z Fun hundred",
  //         isAac: true
  //     ),
  //     MediaSources(
  //         url: "https://api.radioking.io/widget/radio/bankable-radio/track/current", // dummy url
  //         description: "Hiru FM Sri Lanka",
  //         isPrimary: false,
  //         title: "HiruFM",
  //         isAac: false
  //     ),
  //   ],
  // );


  @override
  Widget build(BuildContext context) {
    final radios = audioQuery.querySongs(uriType: UriType.EXTERNAL);
    final radioUrl = radios.then((value) => value[0].data);

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
                        controller: controller,
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
                        MiniPlayer().mini(context, radioUrl.toString(), songs);
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
