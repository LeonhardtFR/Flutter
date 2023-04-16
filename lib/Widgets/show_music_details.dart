import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/playerController.dart';

class ShowMusicDetails {
  void showMusicDetailsModal(BuildContext context, SongModel song) {
    PlayerController playerController = Get.find<PlayerController>();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          color: Theme
              .of(context)
              .colorScheme
              .onSecondaryContainer,
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('Title'),
                subtitle: Text(
                    song.title),
              ),
              ListTile(
                title: const Text('Artist'),
                subtitle: Text(
                    song.artist ?? "Unknown"),
              ),
              ListTile(
                title: const Text('Album'),
                subtitle: Text(
                    song.album ?? "Unknown"),
              ),
              ListTile(
                title: const Text('Time'),
                subtitle: Text(
                  "${NumberFormat("00").format(song.duration! ~/ 60000)}:${NumberFormat("00").format((song.duration! % 60000) ~/ 1000)}",
                   ),
              ),
              ListTile(
                title: const Text('File Extension'),
                subtitle: Text(
                    song.fileExtension.toUpperCase()),
              ),
              ListTile(
                title: const Text('Storage Path'),
                subtitle: Text(
                    song.data),
              ),
            ],
          ),
        );
      },
    );
  }
}