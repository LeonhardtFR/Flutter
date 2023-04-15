import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Helpers/audio_query.dart';
import 'package:osbrosound/Widgets/animated_text.dart';
import 'package:osbrosound/Widgets/show_music_details.dart';

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
  ShowMusicDetails showMusicDetails = ShowMusicDetails();

  var logger = Logger(
    printer: PrettyPrinter(methodCount: 0, lineLength: 1),
  );

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
    try {
      if (controller.maxDuration.value == controller.value.value) {
        controller.playMusic(widget.listSongs[controller.playIndex.value + 1],
            controller.playIndex.value + 1);
      }
    } catch (e) {
      logger.w("WARNING : list index out of range");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_downward,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: controller.backgroundColor.value,
          ),
        ),
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              Navigator.pop(context);
            }
          },
          child: Column(
            children: [
              Expanded(
                child: Obx(
                      () => Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: OfflineAudioQuery.offlineArtworkWidget(
                          id: widget.listSongs[controller.playIndex.value].id,
                          type: ArtworkType.AUDIO,
                          fileName: widget
                              .listSongs[controller.playIndex.value].displayNameWOExt,
                          tempPath: widget.tempPath,
                          width: 350,
                          height: 350,
                          onImageLoaded: (imageBytes) async {
                            controller.backgroundColor.value =
                                await controller.getDominantColors(imageBytes);
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 35,
                        child: Container(
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              showMusicDetails.showMusicDetailsModal(context, widget.listSongs[controller.playIndex.value]);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                          text:
                              widget.listSongs[controller.playIndex.value].title,
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground),
                        ),
                        const SizedBox(height: 16),

                        // SOUS TITRE MUSIQUE
                        AnimatedText(
                          text:
                              widget.listSongs[controller.playIndex.value].title,
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onBackground),
                          height: 20,
                          velocity: 35,
                        ),

                        const SizedBox(height: 75),

                        Row(
                          children: [
                            Text(controller.position.value,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
                            Expanded(
                                child: Slider(
                                    activeColor:
                                        Theme.of(context).colorScheme.secondary,
                                    inactiveColor:
                                        Theme.of(context).unselectedWidgetColor,
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
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
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
                                    logger.w("WARNING : list index out of range");
                                  }
                                },
                                icon: Icon(
                                  Icons.skip_previous,
                                  color:
                                      Theme.of(context).colorScheme.onBackground,
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
                                  ? Icon(Icons.pause,
                                      color:
                                          Theme.of(context).colorScheme.secondary,
                                      size: 36)
                                  : Icon(Icons.play_arrow,
                                      color:
                                          Theme.of(context).colorScheme.secondary,
                                      size: 36),
                            ),
                            IconButton(
                                onPressed: () {
                                  try {
                                    controller.playMusic(
                                        widget.listSongs[
                                            controller.playIndex.value + 1],
                                        controller.playIndex.value + 1);
                                  } catch (e) {
                                    logger.w("WARNING : list index out of range");
                                  }
                                },
                                icon: Icon(
                                  Icons.skip_next,
                                  color: Theme.of(context).colorScheme.secondary,
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
      ),
    );
  }
}
