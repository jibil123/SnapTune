import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/model.dart';

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

// end songfetch,add and show 


Future<void>addLikedSongs(int songId)async{
  final box= await Hive.openBox<LikedSongModel>('Liked_Songs');
  final songs= LikedSongModel(id: songId);
  await box.add(songs);
  print(box.length);
}

List<int>favSongs=[];
ifLickedSongs()async{
  favSongs.clear();
  final box=await Hive.openBox<LikedSongModel>('Liked_Songs');
  List<LikedSongModel>likeSong=box.values.toList();
  for(LikedSongModel songs in likeSong){
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

Future<List<MusicModel>>showLikedSongs()async{
  final box= await Hive.openBox<LikedSongModel>('Liked_Songs');
  List<MusicModel>likedSongs=[];

  List<MusicModel>song=await getAllSongs();

  
  for(int i=0;i<song.length;i++){
    for(int j=0;j<box.length;j++){
      if(box.values.toList()[j].id==song[i].id){
        likedSongs.add(song[i]);
      }
    }
  }
  return likedSongs;
}

  // end of likedsongs

  // Future<void>addPlaylist(String name)async{
  //  final playlistDB=Hive.openBox<PlaylistSongModel>('playlist');
  //  final songs=PlaylistSongModel(name: name, playlistmodel: playlistSong);
  //  await playlistDB.

  // }


