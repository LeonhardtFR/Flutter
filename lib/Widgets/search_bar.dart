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

  // buildAction + buildLeading + buildResults + buildSuggestions = méthode héritée de SearchDelegate

  // construit les actions à afficher dans la barre de recherche (btn par exemple)
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        color: Theme.of(context).colorScheme.primary,
        child: IconButton(
          icon:
              Icon(Icons.clear, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            query = '';
          },
        ),
      ),
    ];
  }

  // construit le bouton de retour (ce qui a avant la barre de recherche)
  @override
  Widget buildLeading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: IconButton(
        icon: Icon(Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  // construit le résultat de la recherche mais pas utilisé car je me sert de buildSuggestions
  // pour afficher les résultats
  @override
  Widget buildResults(BuildContext context) => Container();

  // construit les résultats de la recherche, filtre les résultats en fonction de la query
  // puis les "suggestion" sont affiché dans le ListView.builder
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = listSongs
        .where(
            (song) => song.title.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return Container(
      color: Theme.of(context).colorScheme.primary,
      // ListView.builder pour afficher les résultats de la recherche dans une liste déroulante
      // construit uniquement les resultats visible à l'écran => meilleur perf
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) { // construit la liste en fonction de l'index
          final song = suggestions[index];
          // listTile pour afficher les résultats de la recherche
          return ListTile(
            leading: OfflineAudioQuery.offlineArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              fileName: song.displayNameWOExt,
              tempPath: libraryController.tempPath,
              width: 40,
              height: 40,
            ),
            title: Text(
              song.title,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),

            onTap: () {
              var controller = Get.put(PlayerController());
              int selectedIndex = listSongs.indexOf(song);
              controller.playMusic(listSongs[selectedIndex], selectedIndex);

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => Player(
                    tempPath: libraryController.tempPath!,
                    listSongs: libraryController.listSongs,
                  ),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (_, a, __, c) => FadeTransition(
                    opacity: a,
                    child: c,
                  ),
                ),
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
