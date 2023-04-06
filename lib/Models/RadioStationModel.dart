import 'package:on_audio_query/on_audio_query.dart';

class RadioStation {
  final String title;
  final String artist;
  final String? imageUrl;
  final String? streamUrl;

  RadioStation({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.streamUrl,
  });
}
