import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/model.dart';

  // ValueNotifier<List<MusicModel>>songmodelNotifier=ValueNotifier([]);

  Future<void> addSong({required List<SongModel> song}) async {
  final songDB = await Hive.openBox<MusicModel>('Song_Model');

  for (SongModel element in song) {
    // Check if a song with the same ID already exists
    if (!songDB.containsKey(element.id)) {
      songDB.put(element.id, MusicModel(
        id: element.id,
        name: element.title,
        artist: element.artist.toString(),
        uri: element.uri.toString(),
      ));
    }
  }

  for (MusicModel element in songDB.values) {
    print(element.artist);
  }
}

Future<List<MusicModel>> getAllSongs() async {
  final songDB = await Hive.openBox<MusicModel>('Song_Model');
  return songDB.values.toList();
}
