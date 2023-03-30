import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Helpers/audio_query.dart';
import 'package:osbrosound/Screens/Player/MiniPlayer.dart';


class Player extends StatelessWidget {
  final List<SongModel> listSongs;
  Player({Key? key, required this.tempPath, required this.listSongs}) : super(key: key);

  // final List musicList;
  var controller = Get.find<PlayerController>();
  final String tempPath;

  late AudioHandler _audioHandler;

  late AnimationController _animationController;
  late Animation<double> _textAnimation;


  // var item = MediaItem(
  //   id: 'https://example.com/audio.mp3',
  //   album: 'Album name',
  //   title: 'Track title',
  //   artist: 'Artist name',
  //   duration: const Duration(milliseconds: 123456),
  //   artUri: Uri.parse('https://example.com/album.jpg'),
  // );




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: Obx(
              () => Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                alignment: Alignment.center,
                child: OfflineAudioQuery.offlineArtworkWidget(
                  id: listSongs[controller.playIndex.value].id,
                  type: ArtworkType.AUDIO,
                  fileName: listSongs[controller.playIndex.value].displayNameWOExt,
                  tempPath: tempPath,
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
                      // Text(
                      //     listSongs[controller.playIndex.value]
                      //         .displayNameWOExt,
                      //     textAlign: TextAlign.center,
                      //     style: const TextStyle(
                      //         fontSize: 24,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.white)),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        height: 30,
                      child: Marquee(
                        text: listSongs[controller.playIndex.value].title,
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 50.0,
                        velocity: 15.0,
                        pauseAfterRound: const Duration(seconds: 3),
                          ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                          listSongs[controller.playIndex.value]
                              .album
                              .toString(),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      // const SizedBox(height: 20),
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
                                      listSongs[controller.playIndex.value - 1],
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
                                      listSongs[controller.playIndex.value + 1],
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
            MiniPlayer().mini(context, tempPath, listSongs),
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
