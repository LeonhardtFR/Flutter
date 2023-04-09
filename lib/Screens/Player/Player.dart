import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/ButtonNavigation.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Helpers/audio_query.dart';
import 'package:osbrosound/Screens/Library/library.dart';
import 'package:osbrosound/Screens/Player/MiniPlayer.dart';
import 'package:osbrosound/Screens/Player/Player.dart';
import 'package:osbrosound/Widgets/animated_text.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Player extends StatefulWidget {
  final List<dynamic> listSongs;
  final String tempPath;

  const Player({Key? key, required this.tempPath, required this.listSongs})
      : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  PlayerController controller = Get.find<PlayerController>();

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.miniPlayer(true);
      controller.player(false);
    });
  }

  @override
  void initState() {
    super.initState();
    controller.audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _onComplete();
        // controller.playIndex.value + 1;
      }
    });
  }

  // lance la musique suivante lorsque la musique en cours est finie
  void _onComplete() {
    print(controller.value.value);
    try {
      if (controller.maxDuration.value == controller.value.value) {
        controller.playMusic(widget.listSongs[controller.playIndex.value + 1],
            controller.playIndex.value + 1);
      }
    } catch (e) {
      print("INFO : list index out of range");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },
        child: Column(
          children: [
            Expanded(
                child: Obx(
              () => Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                alignment: Alignment.center,
                child: OfflineAudioQuery.offlineArtworkWidget(
                  id: widget.listSongs[controller.playIndex.value].id,
                  type: ArtworkType.AUDIO,
                  fileName: widget
                      .listSongs[controller.playIndex.value].displayNameWOExt,
                  tempPath: widget.tempPath,
                  quality: 1000,
                  width: 300,
                  height: 300,
                ),
              ),
            )),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                key: const Key('player'),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Obx(
                  () => Column(
                    children: [
                      // TITRE MUSIQUE
                      AnimatedText(
                        text: widget
                            .listSongs[controller.playIndex.value].title,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 16),

                      // SOUS TITRE MUSIQUE
                      AnimatedText(
                        text: widget
                            .listSongs[controller.playIndex.value].title,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white),
                        height: 20,
                        velocity: 35,
                      ),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(horizontal: 20),
                      //   height: 20,
                      //   child: Marquee(
                      //     text: widget
                      //         .listSongs[controller.playIndex.value].album
                      //         .toString(),
                      //     style: const TextStyle(
                      //         fontSize: 15, color: Colors.white),
                      //     scrollAxis: Axis.horizontal,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     blankSpace: 100.0,
                      //     velocity: 35.0,
                      //     fadingEdgeEndFraction: 0.1,
                      //     fadingEdgeStartFraction: 0.1,
                      //   ),
                      // ),

                      const SizedBox(height: 75),

                      Row(
                        children: [
                          Text(controller.position.value,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                          Expanded(
                              child: Slider(
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  min: const Duration(seconds: 0)
                                      .inSeconds
                                      .toDouble(),
                                  max: controller.maxDuration.value,
                                  value: controller.value.value,
                                  onChanged: (value) {
                                    controller
                                        .changeDurationToSeconds(value.toInt());
                                    value = value;
                                  })),
                          Text(controller.duration.value,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                // Je passe à la musique précédente dans la liste
                                try {
                                  controller.playMusic(
                                      widget.listSongs[
                                          controller.playIndex.value - 1],
                                      controller.playIndex.value - 1);
                                } catch (e) {
                                  print("INFO : list index out of range");
                                }
                              },
                              icon: const Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                                size: 36,
                              )),

                          IconButton(
                            onPressed: () {
                              // Navigator.pop(context);
                              // print(buttonNavigationController.controlTabIndex.value);

                              if (controller.isPlaying.value) {
                                controller.audioPlayer.pause();
                                controller.isPlaying(false);
                              } else {
                                controller.audioPlayer.play();
                                controller.isPlaying(true);
                              }
                            },
                            icon: controller.isPlaying.value
                                ? const Icon(Icons.pause,
                                    color: Colors.white, size: 36)
                                : const Icon(Icons.play_arrow,
                                    color: Colors.white, size: 36),
                          ),

                          // IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow, color: Colors.white, size: 36,)),
                          IconButton(
                              onPressed: () {
                                try {
                                  controller.playMusic(
                                      widget.listSongs[
                                          controller.playIndex.value + 1],
                                      controller.playIndex.value + 1);
                                } catch (e) {
                                  print("INFO : list index out of range");
                                }
                              },
                              icon: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 36,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
