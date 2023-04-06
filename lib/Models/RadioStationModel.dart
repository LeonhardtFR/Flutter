import 'package:on_audio_query/on_audio_query.dart';

class RadioStation {
  final String radioName;
  final String imageUrl;
  final String title;
  final String artist;
  final String album;
  final String streamUrl;
  final String apiURL;

  RadioStation({
    required this.radioName,
    required this.imageUrl,
    required this.title,
    required this.artist,
    required this.album,
    required this.streamUrl,
    required this.apiURL,
  });

  RadioStation copyWith({
    String? radioName,
    String? imageUrl,
    String? title,
    String? artist,
    String? album,
    String? streamUrl,
    String? apiURL,
  }) {
    return RadioStation(
      radioName: radioName ?? this.radioName,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      streamUrl: streamUrl ?? this.streamUrl,
      apiURL: apiURL ?? this.apiURL,
    );
  }
}



// class RadioStation {
//   final String title;
//   final String artist;
//   final String? imageUrl;
//   final String? streamUrl;
//
//   RadioStation({
//     required this.title,
//     required this.artist,
//     required this.imageUrl,
//     required this.streamUrl,
//   });
// }
