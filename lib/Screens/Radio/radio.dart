import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'dart:convert';

import '../../Controllers/playerController.dart';
import '../../Helpers/audio_query.dart';
import '../../Models/RadioStationModel.dart';
import '../Player/Player.dart';

// 2. Liste de stations de radio avec les informations préconfigurées
final List<RadioStation> radioStations = [
  RadioStation(
    imageUrl: 'https://example.com/image1.png',
    title: 'Radio 1',
    artist: 'Artist 1',
    streamUrl: 'https://streamurl1.com',
  ),
  RadioStation(
    imageUrl: 'https://example.com/image2.png',
    title: 'Radio 2',
    artist: 'Artist 2',
    streamUrl: 'https://streamurl2.com',
  ),
  // Ajoutez plus de stations de radio ici
];

class RadioScreen extends StatelessWidget {
  RadioScreen({Key? key}) : super(key: key);

  OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();
  List<SongModel> listSongs = [];

  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: ListView.builder(
          itemCount: radioStations.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: ListTile(
                title: Text(
                  radioStations[index].title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  radioStations[index].artist!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  controller.playMusic(radioStations[index], index);
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: Player(
                      tempPath: "",
                      listSongs: radioStations,
                    ),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                  controller.miniPlayer(false);
                  controller.player(true);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
