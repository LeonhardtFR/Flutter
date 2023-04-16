import 'dart:typed_data';
import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:image/image.dart' as img;



class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  var playIndex = 0.obs;
  var isPlaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var maxDuration = 0.0.obs;
  var value = 0.0.obs;

  var player = false.obs;
  var miniPlayer = false.obs;

  var showMiniPlayer = false.obs;

  var lastPlayedIndex = -1.obs;

  var backgroundColor = [Colors.black, Colors.black].obs;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration(formatDuration(d));
      maxDuration.value = d?.inSeconds.toDouble() ?? 0;
    });
    audioPlayer.positionStream.listen((p) {
      position(formatDuration(p));
      value.value = p.inSeconds.toDouble() ?? 0;
    });
  }


  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  playMusic(songs, index) {
    playIndex.value = index;
    Uri uriSong = Uri.parse(songs.uri.toString());
    try {
      audioPlayer.setAudioSource(AudioSource.uri(uriSong,
          tag: MediaItem(
              id: songs.id.toString(),
              title: songs.title,
              album: songs.album,
              artist: songs.artist)));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } catch (e) {
      print("Error");
    }
  }

  Future<void> stopPlayer() async {
    await audioPlayer.stop();
  }

  checkPermission() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
    } else {
      print("Permission Denied");
      checkPermission();
    }
  }

  Future<List<Color>> getDominantColors(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageProvider,
    );

    Color dominantColor = paletteGenerator.dominantColor?.color ?? Colors.black;
    PaletteColor? contrastColor;

    for (PaletteColor paletteColor in paletteGenerator.paletteColors) {
      if (paletteColor.color != dominantColor && paletteColor.color.computeLuminance() > 0.5) {
        contrastColor = paletteColor;
        break;
      }
    }

    return [
      dominantColor,
      contrastColor?.color ?? Colors.black,
    ];
  }





}

// verifie si la duree est null (si oui retourn 00:00) sinom
// on verifie si le nbre d'heures est >= 1 (si oui on affiche les heures)
// sinom on affiche que les minutes et secondes
String formatDuration(Duration? d) {
  if (d == null) return "00:00";
  int hours = d.inHours;
  int minutes = d.inMinutes.remainder(60);
  int seconds = d.inSeconds.remainder(60);

  String formattedHours = hours > 0 ? "${hours.toString().padLeft(2, '0')}:": "";
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = seconds.toString().padLeft(2, '0');

  return "$formattedHours$formattedMinutes:$formattedSeconds";
}
