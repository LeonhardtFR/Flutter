import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/ButtonNavigation.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Helpers/audio_query.dart';
import 'package:osbrosound/Screens/Library/library.dart';
import 'package:osbrosound/Screens/Player/MiniPlayer.dart';
import 'package:osbrosound/Screens/Player/Player.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// Je n'ai pas trouvé comment "allumé" le miniPlayer quand on quitte le "Player" automatiquement
// dans une statelessWidget a l'aide de Get. J'ai donc utilisé un statefullWidget qui permet
// au final de gagner en ressource comme je maitrise l'ouverture et fermerture du miniPlayer.
class Player extends StatefulWidget {
  final List<SongModel> listSongs;
  final String tempPath;

  const Player({Key? key, required this.tempPath, required this.listSongs}) : super(key: key);

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
                      () =>
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: OfflineAudioQuery.offlineArtworkWidget(
                          id: widget.listSongs[controller.playIndex.value].id,
                          type: ArtworkType.AUDIO,
                          fileName:
                          widget.listSongs[controller.playIndex.value]
                              .displayNameWOExt,
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
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16)),
                ),
                child: Obx(
                      () =>
                      Column(
                        children: [
                          // Text(
                          //     listSongs[controller.playIndex.value]
                          //         .displayNameWOExt,
                          //     textAlign: TextAlign.center,
                          //     style: const TextStyle(
                          //         fontSize: 24,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.white)),

                          // TITRE MUSIQUE
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20),
                            height: 35,
                            child: Marquee(
                              text: widget.listSongs[controller.playIndex.value]
                                  .title,
                              style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 80.0,
                              velocity: 25.0,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // SOUS TITRE MUSIQUE
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20),
                            height: 20,
                            child: Marquee(
                              text: widget.listSongs[controller.playIndex.value]
                                  .album
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 100.0,
                              velocity: 35.0,
                            ),
                          ),

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
                                            .changeDurationToSeconds(
                                            value.toInt());
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
                                          widget.listSongs[controller.playIndex
                                              .value - 1],
                                          controller.playIndex.value - 1);
                                    } catch (e) {
                                      print("INFO : list index out of range");
                                    }
                                    // controller.playMusic(songs[controller.playIndex.value - 1].uri, controller.playIndex.value - 1);
                                  },
                                  icon: const Icon(
                                    Icons.skip_previous,
                                    color: Colors.white,
                                    size: 36,
                                  )),

                              IconButton(
                                onPressed: () {
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
                                          widget.listSongs[controller.playIndex
                                              .value + 1],
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
      // bottomNavigationBar: Container(
      //   height: 100,
      //   color: Colors.black,
      //   child: MiniPlayer().mini(context, tempPath, listSongs),
      // )


      // bottomNavigationBar: Text("test", style: TextStyle(color: Colors.white),),
    );
  }
}

