// ignore: file_names
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/songmodel/model.dart';

final OnAudioQuery _onAudioQuery = OnAudioQuery();

 Future<List<MusicModel>> fetchsongtodb() async {
  final songDB = await Hive.openBox<MusicModel>('Song_Model');
  
  // Fetch existing songs from the database
  List<MusicModel> existingSongs = songDB.values.toList();

  // Query new songs
  List<SongModel> songList = await _onAudioQuery.querySongs(
    sortType: null,
    ignoreCase: true,
    orderType: OrderType.ASC_OR_SMALLER,
    uriType: UriType.EXTERNAL,
  );

  // Add new songs to the database if they are not already present
  for (SongModel newSong in songList) {
    bool exists = existingSongs.any((existingSong) => existingSong.id == newSong.id);

    if (!exists) {
      songDB.add(MusicModel(
        id: newSong.id,
        name: newSong.title,
        artist: newSong.artist.toString(),
        uri: newSong.uri.toString(),
      ));
    }
  }

  // Return all songs including the newly added ones
  return songDB.values.toList();
}
