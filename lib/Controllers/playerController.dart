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

  playMusic(List song, index) {
    playIndex.value = index;
    // Songmodel iterables

    print(playIndex.value);
    Uri uriSong = Uri.parse(song[index].uri);
    try {
      audioPlayer.setAudioSource(AudioSource.uri(uriSong));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } catch (e) {
      print(e.toString());
    }
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

// class PlayerController extends StatefulWidget {
//
//   PlayerController({Key? key}) : super(key: key);
//
//   @override
//   _PlayerControllerState createState() => _PlayerControllerState();
// }
//
// class _PlayerControllerState extends State<PlayerController> {
//   final audioQuery = OnAudioQuery();
//   final audioPlayer = AudioPlayer();
//   late int playIndex;
//   static bool isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     checkPermission();
//   }
//
//   playMusic(String? uri, index) {
//     playIndex = index;
//     try {
//       audioPlayer.setAudioSource(
//         AudioSource.uri(Uri.parse(uri!))
//       );
//       audioPlayer.play();
//       isPlaying = true;
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
//
//   void checkPermission() async {
//     var permission = await Permission.storage.request();
//     if (permission.isGranted) {
//     } else {
//       checkPermission();
//     }
//   }
// }
