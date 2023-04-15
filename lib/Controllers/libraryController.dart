import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/settings_controller.dart';
import '../Helpers/audio_query.dart';

class LibraryController extends GetxController {
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

  var logger = Logger(
    printer: PrettyPrinter(methodCount: 0, lineLength: 1),
  );

  Future<void> getMusic() async {
    try {
      // await Permission.audio.request();
      // await Permission.storage.request();
      // await Permission.manageExternalStorage.request();
      await offlineAudioQuery.requestPermission();
      // await Permission.storage.request();

      // if(widget.takeAlbum != null) {
      //   Logger.root.info("User take album from album page");
      //   listSongs = widget.takeAlbum!;
      // } else {
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
    print("listSong : " + listSongs.toString());

    // if (await Permission.storage.isGranted &&
    //     await Permission.audio.isGranted) {
    logger.i("Permission granted");
    var music = await offlineAudioQuery.getSongs();

    if (music.isNotEmpty) {
      musicExist.value = true;
    }
    getAlbums(listSongs);
    getArtists(listSongs);
    getGenres(listSongs);
  }
  // }

  Future<void> getAlbums(listSongs) async {
    for (int i = 0; i < listSongs.length; i++) {
      try {
        if (listAlbums.containsKey(listSongs[i].album ?? "Unknown")) {
          listAlbums[listSongs[i].album ?? "Unknown"]!.add(listSongs[i]);
        } else {
          listAlbums[listSongs[i].album ?? "Unknown"] = [listSongs[i]];
          sortedlistAlbums.add(listSongs[i].album ?? "Unknown");
        }
      } catch (e) {
        logger.e("Error while adding song to album: $e");
      }
    }
  }

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