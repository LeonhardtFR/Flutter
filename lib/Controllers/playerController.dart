import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  var playIndex = 0.obs;
  var isPlaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var maxDuration = 0.0.obs;
  var value = 0.0.obs;

  var player = false.obs;
  var miniPlayer = false.obs;

  var showMiniPlayer = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration(d.toString().split('.').first);
      maxDuration.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      position(p.toString().split('.').first);
      value.value = p!.inSeconds.toDouble();
    });
  }

  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  playMusic(songs, index) {
    playIndex.value = index;
    Uri uriSong = Uri.parse(songs.uri.toString());
    print('Test : ' + songs.id.toString());
    try {
      audioPlayer.setAudioSource(AudioSource.uri(uriSong,
          tag: MediaItem(
              id: songs.id.toString(),
              title: songs.title,
              album: songs.album,
              artist: songs.artist)));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } catch (e) {
      print("Error");
    }
  }

  Future<void> switchToOfflinePlayer(List<String> paths) async {
    final items = paths
        .map((path) => MediaItem(
        id: path,
        album: "Offline Album",
        title: "Offline Song",
        artUri: Uri.parse("https://example.com/cover_art.jpg")))
        .toList();

    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(children: items.map((item) => AudioSource.uri(Uri.file(item.id), tag: item)).toList()),
    );
  }

  Future<void> switchToRadioPlayer(String url) async {
    final mediaItem = MediaItem(
      id: url,
      album: "Bankable Radio",
      title: "Live Stream",
      artUri: Uri.parse("https://example.com/cover_art.jpg"),
    );

    await audioPlayer.setAudioSource(
      AudioSource.uri(Uri.parse(url), tag: mediaItem),
    );
  }

  Future<void> stopPlayer() async {
    await audioPlayer.stop();
  }

  checkPermission() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
    } else {
      print("Permission Denied");
      checkPermission();
    }
  }
}










// import 'package:audio_service/audio_service.dart';
// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:osbrosound/Helpers/audio_query.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../AudioManager.dart';
//


// class PlayerController extends GetxController {
//   final audioQuery = OnAudioQuery();
//   final audioPlayer = AudioPlayer();
//
//   var playIndex = 0.obs;
//   var isPlaying = false.obs;
//
//   var duration = ''.obs;
//   var position = ''.obs;
//
//   var maxDuration = 0.0.obs;
//   var value = 0.0.obs;
//
//   var player = false.obs;
//   var miniPlayer = false.obs;
//
//   var showMiniPlayer = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     checkPermission();
//   }
//
//   updatePosition() {
//     audioPlayer.durationStream.listen((d) {
//       duration(d.toString().split('.').first);
//       maxDuration.value = d!.inSeconds.toDouble();
//     });
//     audioPlayer.positionStream.listen((p) {
//       position(p.toString().split('.').first);
//       value.value = p!.inSeconds.toDouble();
//     });
//   }
//
//   changeDurationToSeconds(seconds) {
//     var duration = Duration(seconds: seconds);
//     audioPlayer.seek(duration);
//   }
//
//   playMusic(songs, index) {
//     playIndex.value = index;
//     Uri uriSong = Uri.parse(songs.uri.toString());
//     print('Test : ' + songs.id.toString());
//     try {
//       audioPlayer.setAudioSource(AudioSource.uri(uriSong,
//           tag: MediaItem(
//               id: songs.id.toString(),
//               title: songs.title,
//               album: songs.album,
//               artist: songs.artist)));
//       audioPlayer.play();
//       isPlaying(true);
//       updatePosition();
//     } catch (e) {
//       print("Error");
//     }
//   }
//
//   checkPermission() async {
//     var permission = await Permission.storage.request();
//     if (permission.isGranted) {
//     } else {
//       print("Permission Denied");
//       checkPermission();
//     }
//   }
// }
