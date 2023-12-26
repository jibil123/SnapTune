import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:snaptune/sceens/albumscreen.dart';

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({super.key});

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
  final AudioPlayer _audioPlayer = AudioPlayer();

  void playsong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(uri ?? ""),
      ));
      _audioPlayer.play();
    } on Exception {
      print('object');
    }
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Icon(
                      Icons.music_note,
                      size: 40,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
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
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text('All Songs',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: _mediaquery.size.height * 0.015,
              ),
              Divider(),
              Expanded(
                  child: FutureBuilder<List<SongModel>>(
                      future: _onAudioQuery.querySongs(
                          sortType: null,
                          ignoreCase: true,
                          orderType: OrderType.ASC_OR_SMALLER,
                          uriType: UriType.EXTERNAL),
                      builder: (context, item) {
                        if (item.data == null) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (item.data!.isEmpty) {
                          return Text('song not found');
                        }
                        return ListView.builder(
                          itemBuilder: (context, index) => ListTile(
                            leading: Icon(Icons.music_note),
                            title: Text(item.data![index].displayNameWOExt),
                            subtitle: Text("${item.data![index].artist}"),
                            trailing: Icon(Icons.more_horiz),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlbumScreen(
                                            songModel: item.data![index],
                                            audioPlayer: _audioPlayer,
                                          )));
                            },
                          ),
                          itemCount: item.data!.length,
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
