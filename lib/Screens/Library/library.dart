import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Controllers/playerController.dart';
import 'package:osbrosound/Helpers/audio_query.dart';
import 'package:osbrosound/Screens/Player/Player.dart';
import 'package:osbrosound/Services/player_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';

late AudioHandler _audioHandler;


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
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  List<SongModel> listSongs = [];

  String? tempPath = '/storage/emulated/0/Music';

  // Appbar controller
  TabController? _tabController;

  // Variable qui va détecter si il y a de la musique dans la librairie
  OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();

  // De base, il ne détecte pas de musique dans la librairie
  bool musicExist = false;

  List<PlaylistModel> playlistDetails = [];

  final Map<String, List<SongModel>> _albums = {};
  final Map<String, List<SongModel>> _artists = {};
  final Map<String, List<SongModel>> _genres = {};

  final List<String> _sortedAlbumKeysList = [];
  final List<String> _sortedArtistKeysList = [];
  final List<String> _sortedGenreKeysList = [];

  @override
  void initState() {
    // audioHandler();
    _tabController = TabController(length: 4, vsync: this);
    getMusic();
    // requestPermission();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  Future<void> getMusic() async {
    try {
      await Permission.audio.request();
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
      await offlineAudioQuery.requestPermission();

      listSongs = List<SongModel>.from(await offlineAudioQuery.getSongs(
          sortType: SongSortType.DISPLAY_NAME,
          orderType: OrderType.ASC_OR_SMALLER));
    } catch (e) {
      Logger.root.severe("Error while requesting permission: $e");
    }

    var music = await offlineAudioQuery.getSongs();

    if (music.isNotEmpty) {
      setState(() {
        musicExist = true;
      });
    }
  }

  // WIDGET BUILD METHOD \\
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
            child: DefaultTabController(
          length: 4,
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
                controller: _tabController,
                onTap: (int index) {
                  setState(() {
                    _tabController!.index = index;
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
                    controller: _tabController,
                    children: [
                      MusicTab(listSongs: listSongs, tempPath: tempPath!),
                      const Center(
                          child: Text('Albums',
                              style: TextStyle(color: Colors.white))),
                      const Center(
                          child: Text('Artists',
                              style: TextStyle(color: Colors.white))),
                      const Center(
                          child: Text('Genres',
                              style: TextStyle(color: Colors.white)))
                    ],
                  ),
          ),
        ))
      ],
    ));
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
              controller.playMusic(widget.listSongs[index].uri, index);
              Get.to(() =>
                  Player(
                    listSongs: widget.listSongs,
                    tempPath: widget.tempPath,
                  ));
            },
          ),
        );
      },
    );
  }
}

class albumTab extends StatefulWidget {
  const albumTab({Key? key}) : super(key: key);

  @override
  State<albumTab> createState() => _albumTabState();
}

class _albumTabState extends State<albumTab> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}