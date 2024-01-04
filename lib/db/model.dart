import 'package:hive/hive.dart';
part 'model.g.dart';

@HiveType(typeId: 1)
class MusicModel {
  @HiveField(0)
  int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String artist;
  @HiveField(3)
  final String uri;

  MusicModel(
      {required this.id,
      required this.name,
      required this.artist,
      required this.uri});
}

@HiveType(typeId: 2)
class LikedSongModel extends HiveObject{

  @HiveField(0)
  int id;
  LikedSongModel({
    required this.id
  });
}


// @HiveType(typeId: 3)
// class PlaylistSongModel {

//   @HiveField(0)
//   String name;
//   @HiveField(1)
//   List playlistmodel=[];

//   PlaylistSongModel({
//     required this.name,
//     required this.playlistmodel,
//   });
// }