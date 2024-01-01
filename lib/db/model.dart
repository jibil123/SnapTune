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



