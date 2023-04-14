import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../Controllers/libraryController.dart';

class LibraryNotifier extends ChangeNotifier {
  bool isChange = false;

  List<SongModel> listSongs = [];
}
