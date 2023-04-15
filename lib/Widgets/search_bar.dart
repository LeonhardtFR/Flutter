import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/libraryController.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Helpers/audio_query.dart';
import 'package:osbrosound/Screens/Player/Player.dart';
import 'package:osbrosound/themes/theme_app.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SongSearchDelegate extends SearchDelegate<SongModel> {
  final List<SongModel> listSongs;

  SongSearchDelegate({required this.listSongs});

  final libraryController = Get.put(LibraryController());

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        color: Theme.of(context).colorScheme.primary,
        child: IconButton(
          icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            query = '';
          },
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = listSongs
        .where((song) => song.title.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final song = suggestions[index];
          return ListTile(
              leading: OfflineAudioQuery.offlineArtworkWidget(
              id: song.id,
          type: ArtworkType.AUDIO,
          fileName: song.displayNameWOExt,
          tempPath: libraryController.tempPath,
          width: 40,
          height: 40,
          ),


            title: Text(song.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
            onTap: () {
              var controller = Get.put(PlayerController());
              int selectedIndex = listSongs.indexOf(song);
              controller.playMusic(listSongs[selectedIndex], selectedIndex);

              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: Player(
                  tempPath: libraryController.tempPath,
                  listSongs: listSongs,
                ),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );

              controller.miniPlayer(false);
              controller.player(true);

              close(context, song);
            },
          );
        },
      ),
    );
  }

  // custom theme
  @override
  ThemeData appBarTheme(BuildContext context) => appBarThemeApp(context);
}

