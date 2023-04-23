import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Helpers/audio_query.dart';
import 'package:osbrosound/Widgets/animated_text.dart';
import 'package:osbrosound/Widgets/background_container.dart';
import 'package:osbrosound/Widgets/show_music_details.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Player extends StatefulWidget {
  final List<dynamic> listSongs;
  final String tempPath;

  const Player({
    Key? key,
    required this.tempPath,
    required this.listSongs,
  }) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  PlayerController controller = Get.find<PlayerController>();
  ShowMusicDetails showMusicDetails = ShowMusicDetails();
  final PanelController _panelController = PanelController();

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
    controller.audioPlayer.positionStream.listen((position) {
      // détecter la fin de la lecture en cours
      if (controller.audioPlayer.duration != null &&
          position >= controller.audioPlayer.duration!) {
        if (position >= controller.audioPlayer.duration!) {
          // verifie si la position de la musique en cours est égal/sup à la durée de la musique
          _onComplete();
        }
      }
    });
  }

// lance la musique suivante lorsque la musique en cours est finie
  void _onComplete() {
    try {
      controller.playMusic(widget.listSongs[controller.playIndex.value + 1],
          controller.playIndex.value + 1);
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
                color: Theme
                    .of(context)
                    .colorScheme
                    .secondary),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: BackgroundContainer(
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              Navigator.pop(context);
            }
          },
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Obx(
                          () =>
                          Container(
                            alignment: Alignment.center,
                            child: OfflineAudioQuery.offlineArtworkWidget(
                              id: widget.listSongs[controller.playIndex.value]
                                  .id,
                              type: ArtworkType.AUDIO,
                              fileName: widget.listSongs[controller.playIndex
                                  .value]
                                  .displayNameWOExt,
                              tempPath: widget.tempPath,
                              width: 350,
                              height: 350,
                              filterQuality: FilterQuality.high,
                              onImageLoaded: (image) async {
                                controller.backgroundColor.value =
                                await controller.getDominantColors(image);
                              },
                            ),
                          ),
                    ),
                    // on positionne le bouton "info" en bas à droite de la pochette de maniere Fixe
                    Positioned(
                      bottom: 10,
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
                            showMusicDetails.showMusicDetailsModal(context,
                                widget.listSongs[controller.playIndex.value]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  // identifiant unique pour le widget
                  key: const Key('player'),
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Obx(
                              () =>
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // TITRE MUSIQUE
                                  AnimatedText(
                                    text: widget
                                        .listSongs[controller.playIndex.value]
                                        .title,
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color:
                                        Theme
                                            .of(context)
                                            .colorScheme
                                            .onBackground),
                                  ),
                                  const SizedBox(height: 16),

                                  // SOUS TITRE MUSIQUE
                                  AnimatedText(
                                    text: widget
                                        .listSongs[controller.playIndex.value]
                                        .title,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color:
                                        Theme
                                            .of(context)
                                            .colorScheme
                                            .onBackground),
                                    height: 20,
                                    velocity: 35,
                                  ),

                                  const SizedBox(height: 75),

                                  Row(
                                    children: [
                                      Text(controller.position.value,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .onBackground)),
                                      Expanded(
                                          child: Slider(
                                              activeColor:
                                              Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .secondary,
                                              inactiveColor:
                                              Theme
                                                  .of(context)
                                                  .unselectedWidgetColor,
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
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .onBackground)),
                                    ],
                                  ),

                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            // je passe à la musique précédente dans la liste
                                            try {
                                              // recupere musique prec dans la liste et l'autre pour maj la valeur playindex dans playMusic
                                              controller.playMusic(
                                                  widget.listSongs[
                                                  controller.playIndex.value -
                                                      1],
                                                  controller.playIndex.value -
                                                      1);
                                            } catch (e) {
                                              logger
                                                  .w(
                                                  "WARNING : list index out of range");
                                            }
                                          },
                                          icon: Icon(
                                            Icons.skip_previous,
                                            color: Theme
                                                .of(context)
                                                .colorScheme
                                                .onBackground,
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
                                            color: Theme
                                                .of(context)
                                                .colorScheme
                                                .secondary,
                                            size: 36)
                                            : Icon(Icons.play_arrow,
                                            color: Theme
                                                .of(context)
                                                .colorScheme
                                                .secondary,
                                            size: 36),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            try {
                                              controller.playMusic(
                                                  widget.listSongs[
                                                  controller.playIndex.value +
                                                      1],
                                                  controller.playIndex.value +
                                                      1);
                                            } catch (e) {
                                              logger
                                                  .w(
                                                  "WARNING : list index out of range");
                                            }
                                          },
                                          icon: Icon(
                                            Icons.skip_next,
                                            color:
                                            Theme
                                                .of(context)
                                                .colorScheme
                                                .secondary,
                                            size: 36,
                                          )),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  IconButton(
                                    onPressed: () {
                                      if (_panelController.isPanelClosed) {
                                        _panelController.open();
                                      } else {
                                        _panelController.close();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.menu,
                                      // Changer l'icône selon vos préférences
                                      color: Theme
                                          .of(context)
                                          .colorScheme
                                          .onBackground,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                        ),
                      ),

                      SlidingUpPanel(
                        controller: _panelController,
                        maxHeight: MediaQuery
                            .of(context)
                            .size
                            .height * 0.4,
                        minHeight: 0,
                        panel: Container(
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Container(
                                width: 50,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .onBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: widget.listSongs.length,
                                  itemBuilder: (context, index) {
                                    return Obx(
                                          () =>
                                          ListTile(
                                            onTap: () {
                                              controller.playMusic(
                                                  widget.listSongs[index],
                                                  index);
                                            },
                                            leading: OfflineAudioQuery
                                                .offlineArtworkWidget(
                                              id: widget.listSongs[index].id,
                                              type: ArtworkType.AUDIO,
                                              fileName: widget.listSongs[index]
                                                  .displayNameWOExt,
                                              tempPath: widget.tempPath,
                                              width: 50,
                                              height: 50,
                                              filterQuality: FilterQuality.high,
                                            ),
                                            title: Text(
                                              widget.listSongs[index].title,
                                              style: TextStyle(
                                                  color: Theme
                                                      .of(context)
                                                      .colorScheme
                                                      .onBackground),
                                            ),
                                            subtitle: Text(
                                              widget.listSongs[index].artist,
                                              style: TextStyle(
                                                  color: Theme
                                                      .of(context)
                                                      .colorScheme
                                                      .onBackground),
                                            ),
                                            trailing: controller.playIndex
                                                .value == index
                                                ? Icon(
                                              Icons.play_arrow,
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .secondary,
                                            )
                                                : null,
                                          ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
