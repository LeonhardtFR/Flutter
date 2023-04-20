import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Screens/Player/Player.dart';
import 'package:osbrosound/Widgets/animated_text.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MiniPlayer {
  mini(BuildContext context, String tempPath, List<SongModel> listSongs) {
    var controller = Get.find<PlayerController>();
    return Container(
      key: const Key('miniPlayer'),
      padding:
          const EdgeInsets.only(bottom: 30.0, top: 10, left: 12.5, right: 12.5),
      color: Theme.of(context).colorScheme.onSecondaryContainer,
      child: Column(children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => Player(
                  tempPath: tempPath,
                  listSongs: listSongs,
                ),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (_, a, __, c) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(a),
                  child: c,
                ),

                // FadeTransition(opacity: a, child: c),
              ),
            );
            // PersistentNavBarNavigator.pushNewScreen(
            //   context,
            //   screen: Player(tempPath: tempPath, listSongs: listSongs,),
            //   withNavBar: true,
            //   pageTransitionAnimation: PageTransitionAnimation.sizeUp,
            // );
            controller.miniPlayer(false);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                      controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Theme.of(context).colorScheme.secondary),
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
                child: AnimatedText(
                  text: listSongs[controller.playIndex.value].title,
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.secondary),
                  height: 20,
                  velocity: 35,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                "[${listSongs[controller.playIndex.value].fileExtension.toUpperCase()}]",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.stop,
                    color: Theme.of(context).colorScheme.secondary),
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
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
            Expanded(
              child: Slider(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveColor: Theme.of(context).unselectedWidgetColor,
                  min: const Duration(seconds: 0).inSeconds.toDouble(),
                  max: controller.maxDuration.value,
                  value: controller.value.value,
                  onChanged: (value) {
                    controller.changeDurationToSeconds(value.toInt());
                    value = value;
                  }),
            ),
            Text(controller.duration.value,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ],
        ),
      ]),
    );
  }
}
