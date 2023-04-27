import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class OfflineAudioQuery {
  static OnAudioQuery audioQuery = OnAudioQuery();
  static final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');

  Future<void> requestPermission() async {
    while (!await audioQuery.permissionsStatus()) {
      await audioQuery.permissionsRequest();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    if (await Permission.audio.isDenied) {
      await Permission.audio.request();
    }
  }

  Future<List<SongModel>> getSongs({
    SongSortType? sortType,
    OrderType? orderType,
    String? path,
  }) async {
    return audioQuery.querySongs(
      sortType: sortType ?? SongSortType.DATE_ADDED,
      orderType: orderType ?? OrderType.DESC_OR_GREATER,
      path: path,
    );
  }

  Future<List<PlaylistModel>> getPlaylists() async {
    return audioQuery.queryPlaylists();
  }

  Future<bool> createPlaylist({required String name}) async {
    name.replaceAll(avoid, '').replaceAll('  ', ' ');
    return audioQuery.createPlaylist(name);
  }

  Future<bool> removePlaylist({required int playlistId}) async {
    return audioQuery.removePlaylist(playlistId);
  }

  Future<bool> addToPlaylist({
    required int playlistId,
    required int audioId,
  }) async {
    return audioQuery.addToPlaylist(playlistId, audioId);
  }

  Future<bool> removeFromPlaylist({
    required int playlistId,
    required int audioId,
  }) async {
    return audioQuery.removeFromPlaylist(playlistId, audioId);
  }

  Future<bool> renamePlaylist({
    required int playlistId,
    required String newName,
  }) async {
    newName.replaceAll(avoid, '').replaceAll('  ', ' ');
    return audioQuery.renamePlaylist(playlistId, newName);
  }

  Future<List<AlbumModel>> getAlbums({
    AlbumSortType? sortType,
    OrderType? orderType,
    String? path,
  }) async {
    return audioQuery.queryAlbums(
      sortType: sortType,
      orderType: orderType,
      uriType: UriType.EXTERNAL,
    );
  }

  Future<List<ArtistModel>> getArtists({
    ArtistSortType? sortType,
    OrderType? orderType,
    String? path,
  }) async {
    return audioQuery.queryArtists(
        sortType: sortType, orderType: orderType, uriType: UriType.EXTERNAL);
  }

  // récupère l'image de couverture de l'album sur le web via l'API de last.fm
  Future<String> fetchAlbumArtworkOnline(String artist, String album) async {
    const apiKey = '616ec98d57f40fde3ea3dc657ea13961';
    final response = await http.get(Uri.parse(
        'https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=$apiKey&artist=$artist&album=$album&format=json'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['album'] != null &&
          jsonResponse['album']['image'] != null) {
        final imageUrl = jsonResponse['album']['image'].last['#text'];
        if (imageUrl.isNotEmpty) {
          return imageUrl;
        }
      }
    }
    return '';
  }

  // récupere "hors ligne" et sauvegarde l'image de couverture de l'album dans le dossier temporaire
  // si elle n'existe pas déjà sinom retourne le chemin de l'image
  static Future<String> queryNSave({
    required int id,
    required ArtworkType type,
    required String tempPath,
    required String fileName,
    int size = 200,
    int quality = 100,
    ArtworkFormat format = ArtworkFormat.JPEG,
  }) async {
    final File file = File('$tempPath/$fileName.jpg');

    if (!await file.exists()) {
      await file.create();
      final Uint8List? image = await audioQuery.queryArtwork(
        id,
        type,
        format: format,
        size: size,
        quality: quality,
      );
      file.writeAsBytesSync(image!);
    }
    return file.path;
  }

  // widget perso, pour afficher l'image de couverture de l'album dans une Card
  // on utilise ici un FutureBuilder pour attendre que l'image soit sauvegardée
  // avec la fonction queryNSave avant de l'afficher
  static Widget offlineArtworkWidget({
    required int id,
    required ArtworkType type,
    required String tempPath,
    required String fileName,

    // Online parameters
    // required String artist,
    // required String album,
    int size = 200,
    int quality = 100,
    ArtworkFormat format = ArtworkFormat.PNG,
    ArtworkType artworkType = ArtworkType.AUDIO,
    BorderRadius? borderRadius,
    Clip clipBehavior = Clip.antiAlias,
    BoxFit fit = BoxFit.cover,
    FilterQuality filterQuality = FilterQuality.low,
    double height = 50.0,
    double width = 50.0,
    double elevation = 5,
    ImageRepeat imageRepeat = ImageRepeat.noRepeat,
    bool gaplessPlayback = true,
    Widget? errorWidget,
    Widget? placeholder,
    void Function(ImageProvider)? onImageLoaded,
  }) {
    return FutureBuilder<String>(
      future: queryNSave(
        id: id,
        type: type,
        format: format,
        quality: quality,
        size: size,
        tempPath: tempPath,
        fileName: fileName,
      ),
      builder: (context, item) {
        if (item.data != null && item.data!.isNotEmpty) {
          final File file = File(item.data!);
          if (onImageLoaded != null) {
            onImageLoaded(FileImage(file));
          }
          return Card(
            elevation: elevation,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(7.0),
            ),
            clipBehavior: clipBehavior,
            child: Image(
              image: FileImage(
                File(
                  item.data!,
                ),
              ),
              gaplessPlayback: gaplessPlayback,
              repeat: imageRepeat,
              width: width,
              height: height,
              fit: fit,
              filterQuality: filterQuality,
              errorBuilder: (context, exception, stackTrace) {
                return errorWidget ??
                    Image(
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                      image: const AssetImage('assets/cover.png'),
                    );
              },
            ),
          );
        }
        return Card(
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(7.0),
          ),
          clipBehavior: clipBehavior,
          child: placeholder ??
              Image(
                fit: BoxFit.cover,
                height: height,
                width: width,
                image: const AssetImage('assets/cover.png'),
              ),
        );
      },
    );
  }
}
