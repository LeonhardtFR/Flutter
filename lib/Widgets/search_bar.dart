import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Screens/Player/Player.dart';
import 'package:osbrosound/themes/theme_app.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SongSearchDelegate extends SearchDelegate<SongModel> {
  final List<SongModel> listSongs;

  SongSearchDelegate({required this.listSongs});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        color: Colors.black,
        child: IconButton(
          icon: const Icon(Icons.clear),
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
      color: Colors.black,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
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
    String? tempPath = '/storage/emulated/0/Music';
    final suggestions = listSongs
        .where((song) => song.title.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return Container(
      color: Colors.black,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final song = suggestions[index];
          return ListTile(
            title: Text(song.title, style: const TextStyle(color: Colors.white),),
            onTap: () {
              var controller = Get.put(PlayerController());
              int selectedIndex = listSongs.indexOf(song);
              controller.playMusic(listSongs[selectedIndex], selectedIndex);

              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: Player(
                  tempPath: tempPath,
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

  @override
  ThemeData appBarTheme(BuildContext context) => appBarThemeApp(context);
}

