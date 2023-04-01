import 'dart:typed_data';

class SongModel {
  final String id;
  final String displayName;
  final String displayNameWOExt;
  final String artist;
  final String album;
  final Duration duration;
  final String filePath;
  final Uint8List? artwork;

  SongModel({
    required this.id,
    required this.displayName,
    required this.displayNameWOExt,
    required this.artist,
    required this.album,
    required this.duration,
    required this.filePath,
    this.artwork,
  });
}
