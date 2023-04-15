import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class RadioAudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  var isPlaying = false.obs;

  // Méthode pour jouer la radio
  Future<void> playRadio(String url) async {
    try {
      // Créez un objet MediaItem avec les informations nécessaires
      final mediaItem = MediaItem(
          id: url,
          album: "Bankable Radio",
          title: "Live Stream",
          artUri: Uri.parse("https://bankableradio.com/wp-content/uploads/2021/03/BR-Logo-1.png"));

      // Configurez l'AudioSource avec l'objet MediaItem
      await _audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(url), tag: mediaItem));

      _audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture de la radio: $e");
    }
  }
  
  void pauseRadio() {
    _audioPlayer.pause();
  }

  void resumeRadio() {
    _audioPlayer.play();
  }

  Future<void> stopRadio() async {
    await _audioPlayer.stop();
  }

  // Obtenez l'état de lecture (en lecture, en pause, etc.)
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
