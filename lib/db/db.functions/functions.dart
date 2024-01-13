import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/songmodel/model.dart';

Future<void> addSong({required List<SongModel> song}) async {
  final songDB = await Hive.openBox<MusicModel>('Song_Model');

    for (SongModel s in song) {
      songDB.add(MusicModel(
          id: s.id,
          name: s.title,
          artist: s.artist.toString(),
          uri: s.uri.toString()));
    }
  
  for (MusicModel s in songDB.values) {
    print(s.artist);
  }
}

Future<List<MusicModel>> getAllSongs() async {
  final songDB = await Hive.openBox<MusicModel>('Song_Model');
  print(songDB);
  return songDB.values.toList();
}

// void reloadDb() async {
//   print('this is reload');
//   final songDb = await Hive.openBox<MusicModel>('Song_Model');
//   // songDb.clear(); // Be cautious while using this line

//   List<MusicModel> songs = songDb.values.toList();
//   OnAudioQuery _audioQuery = OnAudioQuery();
//   List<SongModel> audio = await _audioQuery.querySongs(
//     sortType: null,
//     orderType: OrderType.ASC_OR_SMALLER,
//     uriType: UriType.EXTERNAL,
//     ignoreCase: true,
//   );

//   for (SongModel song in audio) {
//     // Check if the song already exists in the database
//     bool exists = songs.any((existingSong) => existingSong.id == song.id);

//     if (!exists) {
//       songDb.put(
//         song.id,
//         MusicModel(
//           id: song.id,
//           artist: song.artist.toString(),
//           uri: song.uri.toString(),
//           name: song.title,
//         ),
//       );
//     }
//   }
// }

// end songfetch,add and show

Future<void> addLikedSongs(int songId) async {
  final box = await Hive.openBox<LikedSongModel>('Liked_Songs');
  final songs = LikedSongModel(id: songId);
  await box.add(songs);
  print(box.length);
}

List<int> favSongs = [];
ifLickedSongs() async {
  favSongs.clear();
  final box = await Hive.openBox<LikedSongModel>('Liked_Songs');
  List<LikedSongModel> likeSong = box.values.toList();
  for (LikedSongModel songs in likeSong) {
    favSongs.add(songs.id);
  }
}

Future<void> removeLikedSongs(int songId) async {
  final box = await Hive.openBox<LikedSongModel>('Liked_Songs');

  for (LikedSongModel songs in box.values.toList()) {
    if (songId == songs.id) {
      box.delete(songs.key);
    }
  }
}

Future<List<MusicModel>> showLikedSongs() async {
  final box = await Hive.openBox<LikedSongModel>('Liked_Songs');
  List<MusicModel> likedSongs = [];

  List<MusicModel> song = await getAllSongs();

  for (int i = 0; i < song.length; i++) {
    for (int j = 0; j < box.length; j++) {
      if (box.values.toList()[j].id == song[i].id) {
        likedSongs.add(song[i]);
      }
    }
  }
  return likedSongs;
}

// end of likedsongs

// functions.dart



Future<void> addPlaylist(String name, List<int> playlist) async {
  final playlistDB = await Hive.openBox<PlaylistSongModel>('playlist');
  final songs = PlaylistSongModel(name: name, playlistmodel: playlist);
  await playlistDB.add(songs);
  print('hellow ${playlistDB.values.length}');
}

Future<List<PlaylistSongModel>> getAllPlaylists() async {
  final playlistDB = await Hive.openBox<PlaylistSongModel>('playlist');
  return playlistDB.values.toList();
}

Future<void> deletePlaylist(int key) async {
  final PlaylistBOx = await Hive.openBox<PlaylistSongModel>('playlist');
  PlaylistBOx.delete(key);
}

Future<void> editPlaylistName(
    {required int key, required String newName}) async {
  final playbox = await Hive.openBox<PlaylistSongModel>('playlist');
  final box = playbox.get(key);
  box!.name = newName;
  playbox.put(key, box);
}

  List<int> songIds = [];

Future<void> addSongsToPlaylist(MusicModel song, int key) async {
  final PlaylistBox = await Hive.openBox<PlaylistSongModel>('playlist');
  final box = PlaylistBox.get(key);
  box?.playlistmodel.add(song.id);

  print(box!.playlistmodel.length);

  PlaylistBox.put(key, box);
  getAllSongsToPlaylst(key);
}

Future<bool> ifSongContain(MusicModel song, int key) async {
  bool contain = false;
  final playbox = await Hive.openBox<PlaylistSongModel>('playlist');
  final box = playbox.get(key);
  List<int> ids = box!.playlistmodel;
  for (int i = 0; i < ids.length; i++) {
    if (ids[i] == song.id) {
      contain = true;
    }
  }
  return contain;
}

Future<List<MusicModel>> getAllSongsToPlaylst(int key) async {
  final PlaylistBox = await Hive.openBox<PlaylistSongModel>('playlist');
  final box = PlaylistBox.get(key);

  print("${box!.playlistmodel}");

  List<int> listSongs = [];
  listSongs.addAll(box.playlistmodel);

  return await showPlaylistSongs(listSongs);
}

Future<List<MusicModel>> showPlaylistSongs(List<int> songids) async {
  // final box= await Hive.openBox<PlaylistSongModel>('playlist');
  List<MusicModel> playListSongs = [];

  List<MusicModel> song = await getAllSongs();

  for (int i = 0; i < songids.length; i++) {
    for (int j = 0; j < song.length; j++) {
      if (song[j].id == songids[i]) {
        playListSongs.add(song[j]);
      }
    }
  }
  return playListSongs;
}

Future<void> removeSongFromPlaylist(int key, int songid) async {
  final playbox = await Hive.openBox<PlaylistSongModel>('playlist');
  final box = playbox.get(key);
  box!.playlistmodel.remove(songid);
}

// end of the playlist

Future<void> addRecentlyPlayed(int n) async {
  final playbox = await Hive.openBox<RecentlyPlayedModel>('RecentlyPlayed');
  List<RecentlyPlayedModel> box = playbox.values.toList();

  for (int i = 0; i < box.length; i++) {
    if (box[i].id == n) {
      playbox.delete(box[i].key);
      break;
    }
  }

  playbox.add(RecentlyPlayedModel(id: n));
  print('recentplayadded${playbox.values}');
}

Future<List<MusicModel>> recentlyPlayedSongs() async {
  final recentlyPlayedBox = await Hive.openBox<RecentlyPlayedModel>('RecentlyPlayed');
  List<RecentlyPlayedModel> songs = recentlyPlayedBox.values.toList();
  List<MusicModel> allSongs = await getAllSongs();
  List<MusicModel> recents = [];
  for (int i = 0; i < songs.length; i++) {
    for (int j = 0; j < allSongs.length; j++) {
      if (songs[i].id == allSongs[j].id) {
        recents.add(allSongs[j]);
      }
    }
  }

  return recents.reversed.toList();
}

  Future<void> deleteRecentSong(int songId) async {
  final box = await Hive.openBox<RecentlyPlayedModel>('RecentlyPlayed');
  final indexToDelete =
      box.values.toList().indexWhere((song) => song.id == songId);
  if (indexToDelete != -1) {
    box.deleteAt(indexToDelete);
  }
}