import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/log_callback.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/radioPlayerController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:io';


class PlayerController extends GetxController
    with SingleGetTickerProviderMixin {
  RadioAudioController radioAudioController = Get.find<RadioAudioController>();

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

  RxList<int> waveformSamples = <int>[].obs;



  late final AnimationController animationController;
  late final AnimationController secondaryAnimationController;

  var backgroundColor = [Colors.black, Colors.black].obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    secondaryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    checkPermission();
  }

  @override
  void onClose() {
    animationController.dispose();
    secondaryAnimationController.dispose();
    super.onClose();
  }

  // mets a jour position/duree de la musique en écoutant AudioPlayer
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

  // prend une liste de chanson et un index de la chanson à jouer
  // mets a jour l'index de la chanson en cours de lecture, la charge et la joue
  playMusic(SongModel songs, int index) async {
    playIndex.value = index;
    Uri uriSong = Uri.parse(songs.uri.toString());
    String localFilePath = songs.data;

    try {
      radioAudioController.stopRadio();
      audioPlayer.setAudioSource(AudioSource.uri(uriSong,
          tag: MediaItem(
              id: songs.id.toString(),
              title: songs.title,
              album: songs.album,
              artist: songs.artist)));
      audioPlayer.play();
      isPlaying(true);
      // extractWaveformSamples(localFilePath); // extraire les échantillons de la forme d'onde, désactivé pour le moment
      updatePosition();
    } catch (e) {
      print("Error PlayMusic: $e");
    }
  }


  Future<File> copyContentUriToFile(Uri contentUri) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempFileName = '${DateTime.now().millisecondsSinceEpoch}.temp';
    File tempFile = File('${tempDir.path}/$tempFileName');

    ByteData data = await rootBundle.load(contentUri.toString());
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await tempFile.writeAsBytes(bytes);

    return tempFile;
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

  // renvoit une liste des 2 couleurs dominantes de l'image
  Future<List<Color>> getDominantColors(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      imageProvider,
    );

    Color dominantColor = paletteGenerator.dominantColor?.color ?? Colors.black;
    PaletteColor? contrastColor;

    for (PaletteColor paletteColor in paletteGenerator.paletteColors) {
      if (paletteColor.color != dominantColor &&
          paletteColor.color.computeLuminance() > 0.5) {
        contrastColor = paletteColor;
        break;
      }
    }

    return [
      dominantColor,
      contrastColor?.color ?? Colors.black,
    ];
  }

  void logCallback(Log log, String? message) {
    print("[$log] $message");
  }




// extrait les échantillons de la forme d'onde d'un fichier audio et stocke dans une variable
Future<void> extractWaveformSamples(String audioPath) async {
    print("Extracting waveform samples...");
    final audioFile = File(audioPath);
    final exists = await audioFile.exists();
    if (!exists) {
      print("Audio file does not exist");
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final waveFileName = '${audioPath.split('/').last}_waveform.wave';
    final waveFile = File('${tempDir.path}/$waveFileName');

    final progressStream = JustWaveform.extract(
      audioInFile: audioFile,
      waveOutFile: waveFile,
      zoom: const WaveformZoom.pixelsPerSecond(100),
    );
    progressStream.listen((waveformProgress) {
      print('Progress: %${(100 * waveformProgress.progress).toInt()}');
      if (waveformProgress.waveform != null) {
        final waveform = waveformProgress.waveform!;
        const numSamples = 100;
        final duration = waveform.duration;
        waveformSamples.assignAll(List.generate(numSamples, (i) {
          final position = duration * (i / numSamples);
          final pixel = waveform.positionToPixel(position);
          return waveform.getPixelMin(pixel.toInt()).abs();
        }));
      }
    }, onError: (error) {
      print("Error: $error");
    });
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

  String formattedHours =
      hours > 0 ? "${hours.toString().padLeft(2, '0')}:" : "";
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = seconds.toString().padLeft(2, '0');

  return "$formattedHours$formattedMinutes:$formattedSeconds";
}

