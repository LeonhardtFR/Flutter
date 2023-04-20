import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeController extends GetxController {
  final TextEditingController controllerYtbUrl = TextEditingController();
  var logger = Logger(
    printer: PrettyPrinter(methodCount: 0, lineLength: 1),
  );

  Future<String?> getAudio() async {
    try {
      final yt = YoutubeExplode();
      final youtubeVideo = await yt.videos.get(controllerYtbUrl.text);
      final manifest =
          await yt.videos.streamsClient.getManifest(youtubeVideo.id);

      var youtubeAudio = manifest.audioOnly.first;
      var youtubeAudioStream = yt.videos.streamsClient.get(youtubeAudio);

      if (youtubeAudioStream != null) {
        var fileName = '${youtubeVideo.title}.${youtubeAudio.container.name}'
            .replaceAll(r'\', '')
            .replaceAll('/', '')
            .replaceAll('*', '')
            .replaceAll('?', '')
            .replaceAll('"', '')
            .replaceAll('<', '')
            .replaceAll('>', '')
            .replaceAll('|', '');

        final musicDirectory = Directory('/storage/emulated/0/Music/Youtube');

        // cree le repertoire si il n'existe pas
        if (!musicDirectory.existsSync()) {
          musicDirectory.createSync();
        }

        // cree le fichier audio
        var file = File('${musicDirectory.path}/$fileName');

        if (file.existsSync()) {
          file.deleteSync();
        }

        var stream = yt.videos.streamsClient.get(youtubeAudio);
        var fileStream = file.openWrite();
        await stream.pipe(fileStream);
        await fileStream.flush();
        await fileStream.close();
        logger.i('Audio-only stream saved to ${file.path}');
        return file.path;
      }
    } catch (e) {
      logger.e('Error while getting the audio-only stream: $e');
    }
    return null;
  }

  @override
  void onClose() {
    super.onClose();
    controllerYtbUrl.dispose();
  }
}
