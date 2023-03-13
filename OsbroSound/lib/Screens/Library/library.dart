import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:osbrosound/Helpers/audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  List<SongModel> _songs = [];

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

  // final Map<int, SongSortType> songSortTypes = {
  //   0: SongSortType.DISPLAY_NAME,
  //   1: SongSortType.DATE_ADDED,
  //   2: SongSortType.ALBUM,
  //   3: SongSortType.ARTIST,
  //   4: SongSortType.DURATION,
  //   5: SongSortType.SIZE,
  // };
  //
  // final Map<int, OrderType> songOrderTypes = {
  //   0: OrderType.ASC_OR_SMALLER,
  //   1: OrderType.DESC_OR_GREATER,
  // };

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    getMusic();
    // requestPermission();dd
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  // void requestPermission() {
  //   Permission.storage.request();
  // }

  // void requestPermission() async {
  //   var status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     print("OK");
  //   } else {
  //     print("KO");
  //   }
  // }

  Future<void> getMusic() async {
    try {
      await Permission.audio.request();
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
      await offlineAudioQuery.requestPermission();
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
            backgroundColor: Colors.transparent,
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
                      MusicTab(musicList: _songs, tempPath: tempPath!),
                      MusicTab(musicList: _songs, tempPath: tempPath!),
                      MusicTab(musicList: _songs, tempPath: tempPath!),
                      MusicTab(musicList: _songs, tempPath: tempPath!)
                      // Center(child: Text('Songs', style: TextStyle(color: Colors.white)))
                    ],
                  ),

            // body: const TabBarView(
            //   children: [
            //     Center(child: Text('Songs')),
            //     Center(child: Text('Albums')),
            //     Center(child: Text('Artists')),
            //     Center(child: Text('Genres')),
            //   ],
            // ),
          ),
        ))
      ],
    ));
  }
}

class MusicTab extends StatefulWidget {
  final List musicList;
  final String tempPath;

  const MusicTab({Key? key, required this.musicList, required this.tempPath})
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
    super.build(context);
    return ListView.builder(
        itemCount: widget.musicList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.musicList[index].title),
            subtitle: Text(widget.musicList[index].artist),
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.musicList[index].albumArtwork),
            ),
            trailing: IconButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MusicPlayerPage(musicList: widget.musicList, index: index, tempPath: widget.tempPath)));
              },
              icon: const Icon(Icons.play_arrow),
            ),
          );
        });
  }
}
