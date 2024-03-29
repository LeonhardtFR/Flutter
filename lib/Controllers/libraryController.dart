import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Controllers/settings_controller.dart';
import 'package:osbrosound/Screens/Player/Player.dart';
import 'package:path_provider/path_provider.dart';
import '../Helpers/audio_query.dart';

class LibraryController extends GetxController
    with GetTickerProviderStateMixin {
  var tabIndex = 0.obs;

  // ALBUMS VARIABLES
  var albumTab = false.obs;
  var albumListIndex = 0.obs;

  // ARTISTS VARIABLES
  var artistTab = false.obs;
  var artistListIndex = 0.obs;

  // GENRES VARIABLES
  var genreTab = false.obs;
  var genreListIndex = 0.obs;

  String tempPath = "";

  RxList listSongs = [].obs;
  final settingsController = Get.put(SettingsController());

  // Variable qui va détecter si il y a de la musique dans la librairie
  OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();

  // De base, il ne détecte pas de musique dans la librairie
  RxBool musicExist = false.obs;

  List<PlaylistModel> playlistDetails = [];

  Map<String, List<SongModel>> listAlbums = {};
  Map<String, List<SongModel>> listArtists = {};
  Map<String, List<SongModel>> listGenres = {};

  List<String> sortedlistAlbums = [];
  List<String> sortedlistArtists = [];
  List<String> sortedlistGenres = [];

  OverlayEntry? playerOverlayEntry;

  var logger = Logger(
    printer: PrettyPrinter(methodCount: 0, lineLength: 1),
  );

  // Affiche le player (j'ai fais sa pour pouvoir affiché la librairie pendant que je ferme le player)
  // + animation
  // void showPlayer(context, tempPathPlayer, listSongsPlayer) {
  //   final animationController = AnimationController(
  //     vsync: this,
  //     duration: Duration(milliseconds: 500),
  //   );
  //   playerOverlayEntry = OverlayEntry(builder: (context) {
  //     return Player(
  //       tempPath: tempPathPlayer!,
  //       listSongs: listSongsPlayer,
  //       onDismiss: () {
  //         animationController.reverse().then((_) {
  //           removePlayer();
  //         });
  //       },
  //       animationController: animationController,
  //     );
  //   });
  //   Overlay.of(context).insert(playerOverlayEntry!);
  //   animationController.forward();
  // }
  //
  // void removePlayer() {
  //   playerOverlayEntry?.remove();
  //   playerOverlayEntry = null;
  // }

  final suggestions = <SongModel>[].obs;

  Future<void> getMusic() async {
    tempPath = (await getTemporaryDirectory()).path;
    try {
      await offlineAudioQuery.requestPermission();
      logger.i("List all songs from library");
      List<SongModel> songs =
          List<SongModel>.from(await offlineAudioQuery.getSongs(
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        path: settingsController.songSelectedDirectory.value,
      ));

      listSongs.assignAll(songs);
      // }
    } catch (e) {
      logger.e("Error while requesting permission: $e");
    }

    logger.i("Permission granted");
    var music = await offlineAudioQuery.getSongs();

    if (music.isNotEmpty) {
      musicExist.value = true;
    }
    getAlbums(listSongs);
    getArtists(listSongs);
    getGenres(listSongs);
  }

  void updateSuggestions(String query, List<SongModel> listSongs) {
    suggestions.value = listSongs
        .where((song) => song.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }


  // Parcourt chaque chanson de la liste et les classes par albums.
  // Si l'album existe deja dans le dictionnaire alors on ajoute la chanson dans la liste de l'album
  Future<void> getAlbums(listSongs) async {
    for (int i = 0; i < listSongs.length; i++) {
      try {
        // on verifie si le dictionnaire "listAlbums" contient une "clé" qui correspond à l'album de la chanson
        // si l'artiste n'est pas défini on le mets dans la clé "Unknown"
        // si l'album existe deja dans le dictionnaire on ajoute la chanson dans la liste de l'album
        if (listAlbums.containsKey(listSongs[i].album ?? "Unknown")) {
          listAlbums[listSongs[i].album ?? "Unknown"]!.add(listSongs[i]);
        } else {
          // si l'album n'est pas dans le dictionnaire on le crée
          // cree nouvelle entrée dans le dico avec l'album comme clé et la chanson comme valeur
          listAlbums[listSongs[i].album ?? "Unknown"] = [listSongs[i]];
          sortedlistAlbums.add(listSongs[i].album ?? "Unknown");
        }
      } catch (e) {
        logger.e("Error while adding song to album: $e");
      }
    }
  }

  // pareil que pour les albums mais pour les artistes
  Future<void> getArtists(listSongs) async {
    for (int i = 0; i < listSongs.length; i++) {
      try {
        if (listArtists.containsKey(listSongs[i].artist ?? "Unknown")) {
          listArtists[listSongs[i].artist ?? "Unknown"]!.add(listSongs[i]);
        } else {
          listArtists[listSongs[i].artist ?? "Unknown"] = [listSongs[i]];
          sortedlistArtists.add(listSongs[i].artist ?? "Unknown");
        }
      } catch (e) {
        logger.e("Error while adding song to artist: $e");
      }
    }
  }

  // pareil que pour les albums mais pour les genres
  Future<void> getGenres(listSongs) async {
    for (int i = 0; i < listSongs.length; i++) {
      try {
        if (listGenres.containsKey(listSongs[i].genre ?? "Unknown")) {
          listGenres[listSongs[i].genre ?? "Unknown"]!.add(listSongs[i]);
        } else {
          listGenres[listSongs[i].genre ?? "Unknown"] = [listSongs[i]];
          sortedlistGenres.add(listSongs[i].genre ?? "Unknown");
        }
      } catch (e) {
        logger.e("Error while adding song to genre: $e");
      }
    }
  }
}
