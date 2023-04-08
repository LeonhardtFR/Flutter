import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Screens/Player/Player.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MiniPlayer {
  mini(BuildContext context, String tempPath, List<SongModel> listSongs) {
    var controller = Get.find<PlayerController>();
    return Container(
      key: const Key('miniPlayer'),
      padding: const EdgeInsets.only(
          bottom: 30.0, top: 0, left: 12.5, right: 12.5),
      color: Colors.transparent,
      child: Column(children: [
        GestureDetector(
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: Player(tempPath: tempPath, listSongs: listSongs,),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.sizeUp,
            );
            controller.miniPlayer(false);
          },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                        controller.isPlaying.value ? Icons.pause : Icons
                            .play_arrow,
                        color: Colors.white),
                    onPressed: () {
                      if (controller.isPlaying.value) {
                        controller.audioPlayer.pause();
                        controller.isPlaying(false);
                      } else {
                        controller.audioPlayer.play();
                        controller.isPlaying(true);
                      }
                    }),
                Expanded(
                    child: SizedBox(
                        height: 25,
                        child: Marquee(
                          blankSpace: 35,
                          velocity: 25,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          text: listSongs[controller.playIndex.value].title,
                        ))),
                const SizedBox(width: 8.0),
                Text(
                  "[${listSongs[controller.playIndex.value]
                      .fileExtension
                      .toUpperCase()}]",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.stop, color: Colors.white),
                  onPressed: () {
                    controller.miniPlayer(false);
                    controller.audioPlayer.pause();
                    controller.audioPlayer.stop();
                    controller.isPlaying(false);
                  },
                ),
              ],
            ),
          ),
        Row(
          children: [
            Text(controller.position.value,
                style: const TextStyle(color: Colors.white)),
            Expanded(
              child: Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                  min: const Duration(seconds: 0).inSeconds.toDouble(),
                  max: controller.maxDuration.value,
                  value: controller.value.value,
                  onChanged: (value) {
                    controller.changeDurationToSeconds(value.toInt());
                    value = value;
                  }),
            ),
            Text(controller.duration.value,
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ]),
    );
  }
}