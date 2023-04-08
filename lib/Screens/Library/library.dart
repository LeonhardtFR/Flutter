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
import 'package:osbrosound/Widgets/search_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../Player/MiniPlayer.dart';

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

  TabController? tabController;

  // Variable qui va détecter si il y a de la musique dans la librairie
  OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();

  // De base, il ne détecte pas de musique dans la librairie
  bool musicExist = false;

  List<PlaylistModel> playlistDetails = [];

  String _albums = "";
  Map<String, List<SongModel>> listAlbums = {};
  Map<String, List<SongModel>> listArtists = {};
  Map<String, List<SongModel>> listGenres = {};

  List<String> sortedlistAlbums = [];
  List<String> sortedlistArtists = [];
  List<String> sortedlistGenres = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var libraryController = Get.put(LibraryController());
      tabController = TabController(
          length: 4,
          vsync: this,
          initialIndex: libraryController.tabIndex.value);
      getMusic();
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
      // await Permission.audio.request();
      // await Permission.storage.request();
      // await Permission.manageExternalStorage.request();
      await offlineAudioQuery.requestPermission();
      // await Permission.storage.request();

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

    // if (await Permission.storage.isGranted &&
    //     await Permission.audio.isGranted) {
    Logger.root.info("Permission granted");
    var music = await offlineAudioQuery.getSongs();

    if (music.isNotEmpty) {
      setState(() {
        musicExist = true;
      });
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
        print("Error while adding song to album: $e");
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
        print("Error while adding song to artist: $e");
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
        print("Error while adding song to genre: $e");
      }
    }
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
                      libraryController.tabIndex.value = index;
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
                    onPressed: () async {
                      SongModel? selectedSong = await showSearch(
                        context: context,
                        delegate: SongSearchDelegate(listSongs: listSongs),
                      );

                      if (selectedSong != null) {
                        int selectedIndex = listSongs.indexOf(selectedSong);
                        var controller = Get.put(PlayerController());
                        controller.playMusic(listSongs[selectedIndex], selectedIndex);

                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: Player(
                            tempPath: tempPath!,
                            listSongs: listSongs,
                          ),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                        controller.miniPlayer(false);
                        controller.player(true);
                      }
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
                        MusicTab(
                          listSongs: listSongs,
                          tempPath: tempPath!,
                        ),
                        AlbumsTab(
                            tempPath: tempPath!,
                            albums: listAlbums,
                            albumsList: sortedlistAlbums),
                        ArtistsTab(
                            tempPath: tempPath!,
                            artists: listArtists,
                            artistsList: sortedlistArtists),
                        GenresTab(
                            tempPath: tempPath!,
                            genres: listGenres,
                            genresList: sortedlistGenres),
                      ],
                    ),
            ),
          )),
          if (listSongs.isNotEmpty)
            Obx(() => Container(
                  color: Colors.black,
                  child: AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      child: controller.miniPlayer.value
                          ? MiniPlayer().mini(context, tempPath!, listSongs)
                          : Container(color: Colors.black)),
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
    var libraryController = Get.put(LibraryController());
    var controller = Get.put(PlayerController());
    super.build(context);

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 25),
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
                controller.playMusic(widget.listSongs[index], index);
                // Get.to(() => Player(
                //   tempPath: widget.tempPath,
                //   listSongs: widget.listSongs,
                // )
                // );

                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: Player(
                    tempPath: widget.tempPath,
                    listSongs: widget.listSongs,
                  ),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );
                controller.miniPlayer(false);
                controller.player(true);
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

  @override
  void initState() {
    super.initState();
    Get.put(LibraryController());
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    var libraryController = Get.put(LibraryController());
    super.build(context);

    // Erreur si aucun album trouvé dans le 'storage' du téléphone
    if (widget.albumsList.isEmpty) {
      return const Center(
        child: Text('No sound found in the storage',
            style: TextStyle(color: Colors.white)),
      );
    }

    // Variable qui permet de savoir si l"utilisateur a cliqué sur un album et le garde en mémoire (si non affiche tout, si oui affiche l'album en question)
    if (libraryController.albumTab.value == false) {
      return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 25),
          shrinkWrap: true,
          itemExtent: 70.0,
          itemCount: widget.albumsList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: OfflineAudioQuery.offlineArtworkWidget(
                id: widget.albums[widget.albumsList[index]]![0].id,
                type: ArtworkType.AUDIO,
                tempPath: widget.tempPath,
                fileName: widget
                    .albums[widget.albumsList[index]]![0].displayNameWOExt,
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
                setState(() {
                  libraryController.albumTab(true);
                  libraryController.albumListIndex.value = index;
                  libraryController.tabIndex.value = 1;
                });
              },
            );
          },
      );
    }
    // Quand l'utilisateur clique sur un album
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                textStyle: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              setState(() {
                libraryController.albumTab(false);
              });
            },
            child: const Text("Show all albums"),
          ),
        ),
        // Liste des chansons de l'album que l'utilisateur a sélectionné
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: ListView.builder(
              itemCount: widget
                  .albums[widget
                      .albumsList[libraryController.albumListIndex.value]]!
                  .length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: ListTile(
                    leading: OfflineAudioQuery.offlineArtworkWidget(
                      id: widget
                          .albums[widget.albumsList[
                              libraryController.albumListIndex.value]]![index]
                          .id,
                      type: ArtworkType.AUDIO,
                      tempPath: widget.tempPath,
                      fileName: widget
                          .albums[widget.albumsList[
                              libraryController.albumListIndex.value]]![index]
                          .displayNameWOExt,
                    ),
                    title: Text(
                      widget
                                  .albums[widget.albumsList[libraryController
                                      .albumListIndex.value]]![index]
                                  .title
                                  .trim() !=
                              ''
                          ? widget
                              .albums[widget.albumsList[libraryController
                                  .albumListIndex.value]]![index]
                              .title
                          : widget
                              .albums[widget.albumsList[libraryController
                                  .albumListIndex.value]]![index]
                              .displayNameWOExt,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      widget
                          .albums[widget.albumsList[
                              libraryController.albumListIndex.value]]![index]
                          .artist!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // print(widget.songs[index].uri);
                      controller.playMusic(
                          widget.albums[widget.albumsList[
                              libraryController.albumListIndex.value]]![index],
                          index);

                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: Player(
                          tempPath: widget.tempPath,
                          listSongs: widget.albums[widget.albumsList[
                              libraryController.albumListIndex.value]]!,
                        ),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                      controller.miniPlayer(false);
                      controller.player(true);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ArtistsTab extends StatefulWidget {
  final String tempPath;
  final Map<String, List<SongModel>> artists;
  final List<String> artistsList;

  const ArtistsTab({
    super.key,
    required this.tempPath,
    required this.artists,
    required this.artistsList,
  });

  @override
  _ArtistsTabTabState createState() => _ArtistsTabTabState();
}

class _ArtistsTabTabState extends State<ArtistsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void initState() {
    super.initState();
    Get.put(LibraryController());
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    var libraryController = Get.put(LibraryController());
    super.build(context);

    // Erreur si aucun album trouvé dans le 'storage' du téléphone
    if (widget.artistsList.isEmpty) {
      return const Center(
        child: Text('No sound found in the storage',
            style: TextStyle(color: Colors.white)),
      );
    }

    // Variable qui permet de savoir si l"utilisateur a cliqué sur un album et le garde en mémoire (si non affiche tout, si oui affiche l'album en question)
    if (libraryController.artistTab.value == false) {
      return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 25),
          shrinkWrap: true,
          itemExtent: 70.0,
          itemCount: widget.artistsList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: OfflineAudioQuery.offlineArtworkWidget(
                id: widget.artists[widget.artistsList[index]]![0].id,
                type: ArtworkType.AUDIO,
                tempPath: widget.tempPath,
                fileName: widget
                    .artists[widget.artistsList[index]]![0].displayNameWOExt,
              ),
              title: Text(
                widget.artistsList[index],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${widget.artists[widget.artistsList[index]]!.length} songs',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  libraryController.artistTab(true);
                  libraryController.artistListIndex.value = index;
                  libraryController.tabIndex.value = 2;
                });
              },
            );
          },
      );
    }
    // Quand l'utilisateur clique sur un artiste
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                textStyle: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              setState(() {
                libraryController.artistTab(false);
              });
            },
            child: const Text("Show all artists"),
          ),
        ),
        // Liste des chansons de l'artiste que l'utilisateur a sélectionné
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: ListView.builder(
              itemCount: widget
                  .artists[widget
                      .artistsList[libraryController.artistListIndex.value]]!
                  .length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: ListTile(
                    leading: OfflineAudioQuery.offlineArtworkWidget(
                      id: widget
                          .artists[widget.artistsList[
                              libraryController.artistListIndex.value]]![index]
                          .id,
                      type: ArtworkType.AUDIO,
                      tempPath: widget.tempPath,
                      fileName: widget
                          .artists[widget.artistsList[
                              libraryController.artistListIndex.value]]![index]
                          .displayNameWOExt,
                    ),
                    title: Text(
                      widget
                                  .artists[widget.artistsList[libraryController
                                      .artistListIndex.value]]![index]
                                  .title
                                  .trim() !=
                              ''
                          ? widget
                              .artists[widget.artistsList[libraryController
                                  .artistListIndex.value]]![index]
                              .title
                          : widget
                              .artists[widget.artistsList[libraryController
                                  .artistListIndex.value]]![index]
                              .displayNameWOExt,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      widget
                          .artists[widget.artistsList[
                              libraryController.artistListIndex.value]]![index]
                          .artist!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // print(widget.songs[index].uri);
                      controller.playMusic(
                          widget.artists[widget.artistsList[
                              libraryController.artistListIndex.value]]![index],
                          index);

                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: Player(
                          tempPath: widget.tempPath,
                          listSongs: widget.artists[widget.artistsList[
                              libraryController.artistListIndex.value]]!,
                        ),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                      controller.miniPlayer(false);
                      controller.player(true);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class GenresTab extends StatefulWidget {
  final String tempPath;
  final Map<String, List<SongModel>> genres;
  final List<String> genresList;

  const GenresTab({
    super.key,
    required this.tempPath,
    required this.genres,
    required this.genresList,
  });

  @override
  _GenresTabTabState createState() => _GenresTabTabState();
}

class _GenresTabTabState extends State<GenresTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Get.put(LibraryController());
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    var libraryController = Get.put(LibraryController());
    super.build(context);

    // Erreur si aucune musique trouvé dans le 'storage' du téléphone
    if (widget.genresList.isEmpty) {
      return const Center(
        child: Text('No sound found in the storage',
            style: TextStyle(color: Colors.white)),
      );
    }

    // Variable qui permet de savoir si l"utilisateur a cliqué sur un album et le garde en mémoire (si non affiche tout, si oui affiche les genres en question)
    if (libraryController.genreTab.value == false) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 25),
        shrinkWrap: true,
        itemExtent: 70.0,
        itemCount: widget.genresList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: OfflineAudioQuery.offlineArtworkWidget(
              id: widget.genres[widget.genresList[index]]![0].id,
              type: ArtworkType.AUDIO,
              tempPath: widget.tempPath,
              fileName: widget
                  .genres[widget.genresList[index]]![0].displayNameWOExt,
            ),
            title: Text(
              widget.genresList[index],
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '${widget.genres[widget.genresList[index]]!.length} songs',
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() {
                libraryController.genreTab(true);
                libraryController.genreListIndex.value = index;
                libraryController.tabIndex.value = 3;
              });
            },
          );
        },
      );
    }
    // Quand l'utilisateur clique sur un genre
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                textStyle: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              setState(() {
                libraryController.genreTab(false);
              });
            },
            child: const Text("Show all genres"),
          ),
        ),
        // Liste des chansons de genre musicaux que l'utilisateur a sélectionné
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: ListView.builder(
              itemCount: widget
                  .genres[widget
                  .genresList[libraryController.genreListIndex.value]]!
                  .length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: ListTile(
                    leading: OfflineAudioQuery.offlineArtworkWidget(
                      id: widget
                          .genres[widget.genresList[
                      libraryController.genreListIndex.value]]![index]
                          .id,
                      type: ArtworkType.AUDIO,
                      tempPath: widget.tempPath,
                      fileName: widget
                          .genres[widget.genresList[
                      libraryController.genreListIndex.value]]![index]
                          .displayNameWOExt,
                    ),
                    title: Text(
                      widget
                          .genres[widget.genresList[libraryController
                          .genreListIndex.value]]![index]
                          .title
                          .trim() !=
                          ''
                          ? widget
                          .genres[widget.genresList[libraryController
                          .genreListIndex.value]]![index]
                          .title
                          : widget
                          .genres[widget.genresList[libraryController
                          .genreListIndex.value]]![index]
                          .displayNameWOExt,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      widget
                          .genres[widget.genresList[
                      libraryController.genreListIndex.value]]![index]
                          .genre!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      controller.playMusic(
                          widget.genres[widget.genresList[
                          libraryController.genreListIndex.value]]![index],
                          index);

                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: Player(
                          tempPath: widget.tempPath,
                          listSongs: widget.genres[widget.genresList[
                          libraryController.genreListIndex.value]]!,
                        ),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                      controller.miniPlayer(false);
                      controller.player(true);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
