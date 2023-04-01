import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/libraryController.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Helpers/audio_query.dart';
import 'package:osbrosound/Screens/Player/Player.dart';
import 'package:osbrosound/Services/player_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';


import '../Player/MiniPlayer.dart';

late AudioHandler _audioHandler;

// Appbar controller
// TabController? tabController;
// var libraryController = Get.put(LibraryController());

// Future<void> audioHandler() async {
//   _audioHandler = await AudioService.init(
//     builder: () => BackgroundAudio(),
//     config: const AudioServiceConfig(
//       androidNotificationChannelId: 'com.osbro.osbrosound',
//       androidNotificationChannelName: 'OsbroSound',
//       androidNotificationIcon: 'mipmap/ic_launcher',
//       androidStopForegroundOnPause: true,
//       androidResumeOnClick: true,
//       androidShowNotificationBadge: true,
//       androidNotificationOngoing: true,
//     ),
//   );
// }

class LibraryPage extends StatefulWidget {
  final String? title;
  final List<SongModel>? takeAlbum;
  const LibraryPage({Key? key, this.title, this.takeAlbum}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {

  List<SongModel> listSongs = [];

  String? tempPath = '/storage/emulated/0/Music';

  // // Appbar controller
  TabController? tabController;

  // Variable qui va détecter si il y a de la musique dans la librairie
  OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();

  // De base, il ne détecte pas de musique dans la librairie
  bool musicExist = false;

  List<PlaylistModel> playlistDetails = [];

  String _albums = "";
  Map<String, List<SongModel>> listAlbums = {};
  final Map<String, List<SongModel>> _artistsList = {};
  final Map<String, List<SongModel>> _genresList = {};

  List<String> sortedlistAlbums = [];
  final List<String> _sortedArtistList = [];
  final List<String> _sortedGenreList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var libraryController = Get.put(LibraryController());
    // audioHandler();
      print("ALED");
      print(libraryController.tabIndex.value);
      tabController = TabController(length: 4, vsync: this, initialIndex: libraryController.tabIndex.value);
    getMusic();

      // if(libraryController.albumTab.value) {
      //   tabController?.index = 1;
      // }

    });
  }

  void stateChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  Future<void> getMusic() async {
    try {
      await Permission.audio.request();
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
      await offlineAudioQuery.requestPermission();

      // if(widget.takeAlbum != null) {
      //   Logger.root.info("User take album from album page");
      //   listSongs = widget.takeAlbum!;
      // } else {
        Logger.root.info("List all songs from library");
        listSongs = List<SongModel>.from(await offlineAudioQuery.getSongs(
            sortType: SongSortType.DISPLAY_NAME,
            orderType: OrderType.ASC_OR_SMALLER));
      // }
    } catch (e) {
      Logger.root.severe("Error while requesting permission: $e");
    }

    var music = await offlineAudioQuery.getSongs();

    if (music.isNotEmpty) {
      setState(() {
        musicExist = true;
      });
    }
    getAlbums(listSongs);
  }


  Future<void> getAlbums(listSongs) async {
    for(int i = 0; i < listSongs.length; i++) {
      try {
        if(listAlbums.containsKey(listSongs[i].album ?? "Unknown")) {
          listAlbums[listSongs[i].album ?? "Unknown"]!.add(listSongs[i]);
        } else {
          listAlbums[listSongs[i].album ?? "Unknown"] = [listSongs[i]];
          sortedlistAlbums.add(listSongs[i].album ?? "Unknown");
        }
      } catch (e) {
        print("Error while adding song to album: $e");
      }
    }

    // Maintenant, vous pouvez utiliser la variable `albums` qui contient tous les albums avec les chansons correspondantes
  }

  // WIDGET BUILD METHOD \\
  @override
  Widget build(BuildContext context) {
    var libraryController = Get.put(LibraryController());
    var controller = Get.put(PlayerController());
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: DefaultTabController(
            length: 4,
            initialIndex: libraryController.tabIndex.value,
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: const Text('Library'),
                backgroundColor: Colors.black,
                bottom: TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.white,
                  indicatorColor: Colors.blueAccent,
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: tabController,
    onTap: (int index) {
      setState(() {
        tabController!.index = index;
      });
    },

                  tabs: const [
                    Tab(text: 'Songs'),
                    Tab(text: 'Albums'),
                    Tab(text: 'Artists'),
                    Tab(text: 'Genres'),
                  ],
                ),

                // Icone de recherche dans l'AppBar
                actions: [
                  IconButton(
                    onPressed: () {
                      // showSearch(context: context, delegate: delegate)
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              body: !musicExist
                  ? const Center(
                      child: CircularProgressIndicator(),
                      // child: Text('No music found in the storage', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)
                    )
                  : TabBarView(
                      controller: tabController,
                      children: [
                        MusicTab(listSongs: listSongs, tempPath: tempPath!,),
                        AlbumsTab(
                            tempPath: tempPath!,
                            albums: listAlbums,
                            albumsList: sortedlistAlbums),
                        const Center(
                            child: Text('Artists',
                                style: TextStyle(color: Colors.white))),
                        const Center(
                            child: Text('Genres',
                                style: TextStyle(color: Colors.white)))
                      ],
                    ),
            ),
          )),

          // On gére une erreur qui se produit quand il n'a pas le temps de récup la liste, on veut etre sur qu'il ai le temps
          // if (listSongs.isNotEmpty && !controller.player.value)
          // Obx(() {
          //   if (listSongs.isNotEmpty && !controller.player.value) {
          //     print("player value: ");
          //   print(controller.player.value);
          //   return Container(
          //       child: MiniPlayer().mini(context, tempPath!, listSongs));
          // } else {
          //   return const SizedBox();
          // }
          // }
    // ),
          // ),

          if (listSongs.isNotEmpty)
            Obx(() =>
                Container(
                  color: Colors.black,
                  child: AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      child: controller.miniPlayer.value
                          ? MiniPlayer().mini(context, tempPath!, listSongs)
                          :  Container(color: Colors.black)),
                )),

        ],
      ),
    );
  }
}

class MusicTab extends StatefulWidget {
  final String tempPath;
  List<SongModel> listSongs = [];


  MusicTab({Key? key, required this.listSongs, required this.tempPath})
      : super(key: key);

  @override
  State<MusicTab> createState() => _MusicTabState();
}

class _MusicTabState extends State<MusicTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    super.build(context);
    return ListView.builder(
      itemCount: widget.listSongs.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
          child: ListTile(
            leading: OfflineAudioQuery.offlineArtworkWidget(
              id: widget.listSongs[index].id,
              type: ArtworkType.AUDIO,
              tempPath: widget.tempPath,
              fileName: widget.listSongs[index].displayNameWOExt,
            ),
            title: Text(
              widget.listSongs[index].title.trim() != ''
                  ? widget.listSongs[index].title
                  : widget.listSongs[index].displayNameWOExt,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              widget.listSongs[index].artist!,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              // print(widget.songs[index].uri);
              controller.playMusic(widget.listSongs[index], index);

              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: Player(tempPath: widget.tempPath, listSongs: widget.listSongs,),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );
              controller.miniPlayer(false);
              controller.player(true);

              // Get.to(() => Player(
              //       listSongs: widget.listSongs,
              //       tempPath: widget.tempPath,
              //     ));
            },
          ),
        );
      },
    );
  }
}

class AlbumsTab extends StatefulWidget {
  final String tempPath;
  final Map<String, List<SongModel>> albums;
  final List<String> albumsList;

  const AlbumsTab({
    super.key,
    required this.tempPath,
    required this.albums,
    required this.albumsList,
  });

  @override
  State<AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void initState() {
    super.initState();
    Get.put(LibraryController());
  }

  @override
  Widget build(BuildContext context) {
    var libraryController = Get.put(LibraryController());
    super.build(context);

    // Erreur si aucun album trouvé
    if(widget.albumsList.isEmpty) {
      return const Center(
        child: Text('No albums found in the storage',
            style: TextStyle(color: Colors.white)),
      );
    }


    if(libraryController.albumTab.value == false) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        shrinkWrap: true,
        itemExtent: 70.0,
        itemCount: widget.albumsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: OfflineAudioQuery.offlineArtworkWidget(
              id: widget.albums[widget.albumsList[index]]![0].id,
              type: ArtworkType.AUDIO,
              tempPath: widget.tempPath,
              fileName: widget.albums[widget.albumsList[index]]![0]
                  .displayNameWOExt,
            ),
            title: Text(
              widget.albumsList[index],
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '${widget.albums[widget.albumsList[index]]!.length} songs',
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              libraryController.albumTab(true);
              libraryController.albumListIndex.value = index;
              libraryController.tabIndex.value = 1;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LibraryPage(
                        title: widget.albumsList[index],
                        takeAlbum: widget.albums[widget.albumsList[index]]!,
                      ),
                ),
              );
            },
          );
        },
      );
    } else {
      return MusicTab(listSongs: widget.albums[widget.albumsList[libraryController.albumListIndex.value]]!, tempPath: widget.tempPath);
    }
  }
}
