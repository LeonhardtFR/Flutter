import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/playerController.dart';

class MiniPlayer {
  mini(BuildContext context, String tempPath, List<SongModel> listSongs) {
    var controller = Get.find<PlayerController>();
    controller.miniPlayer(true);
    return Container(
      key: const Key('miniPlayer'),
      padding: const EdgeInsets.all(12.0),
      color: Colors.black,
      child: Column(children: [
        // if (controller.miniPlayer.value)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                    controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
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
            Text(
              listSongs[controller.playIndex.value].title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8.0),
            Text(
              "[" +
                  listSongs[controller.playIndex.value]
                      .fileExtension
                      .toUpperCase() +
                  "]",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
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
        // if (controller.miniPlayer.value)
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
