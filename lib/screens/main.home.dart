import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:snaptune/db/functions.dart';
import 'package:snaptune/db/model.dart';
import 'package:snaptune/provider/provider.dart';
import 'package:snaptune/screens/albumscreen.dart';
import 'package:snaptune/screens/navigator.visible.dart';

final AudioPlayer audioPlayer = AudioPlayer();

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({
    super.key,
  });

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  void initState() {
    super.initState();
    // request permission
    Permission.storage.request();
  }
  

  final OnAudioQuery _onAudioQuery = OnAudioQuery();

  void playsong(String? uri) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(uri ?? ""),
      ));
      audioPlayer.play();
    } on Exception {
      print('object');
    }
  }
  
  Future<List<MusicModel>> fetchsongtodb() async {
  // Fetch songs only if the database is empty
  final songDB = await Hive.openBox<MusicModel>('Song_Model');
  if (songDB.isEmpty) {
    List<SongModel> songList = await _onAudioQuery.querySongs(
      sortType: null,
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
    addSong(song: songList);
  }

  return getAllSongs();
}
  @override
  Widget build(BuildContext context) {
    var _mediaquery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ const
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: 15),
                    child: Icon(
                      Icons.music_note,
                      size: 40,
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(right: 15),
                    child: Text(
                      'Enjoy  your own  music',
                      style: TextStyle(
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _mediaquery.size.height * 0.015,
              ),
              const Padding(
                padding:  EdgeInsets.only(left: 20),
                child: Text('All Songs',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: _mediaquery.size.height * 0.015,
              ),
              const Divider(),
              Expanded(
                  child: FutureBuilder<List<MusicModel>>(
                      future: fetchsongtodb(),
                      builder: (context, item) {
                        if (item.data == null) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (item.data!.isEmpty) {
                          return Text('song not found');
                        }
                        return ListView.builder(
                          itemCount: item.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                            leading: QueryArtworkWidget(
                              id: item.data![index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Image(image: AssetImage('assets/images/leadingImage.png')),
                            ),
                            title: Text(item.data![index].name,maxLines: 1,overflow: TextOverflow.fade,),
                            subtitle: Text("${item.data![index].artist}",maxLines: 1,overflow: TextOverflow.fade),  
                            trailing:IconButton(onPressed: (){

                            }, icon: Icon(Icons.play_arrow_rounded,size: 40,)),
                            onTap: () {
                              context
                                  .read<songModelProvider>()
                                  .setId(item.data![index].id);
                              VisibilityNav.isvisible = true;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlbumScreen(
                                            songModel: item.data![index],
                                            audioPlayer: audioPlayer, musicModel: item.data![index],
                                          )
                                        ));
                            },
                          );
                          
                          } 
                          
                        );
                  }
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
