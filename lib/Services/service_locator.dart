import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:osbrosound/Services/audio_background.dart';

Future<void> setupServiceLocator() async {
  // services
  // centralisation de la configuration des dépendances,
  // ce qui rend le code plus facile à maintenir et à tester.
  Get.putAsync<AudioHandler>(() => initAudioService());
  // Get.lazyPut<PlaylistRepository>(() => DemoPlaylist());

  // page state
  // Get.lazyPut<PageManager>(() => PageManager());
}
