
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:snaptune/db/functions.dart';
import 'package:snaptune/db/model.dart';
import 'package:snaptune/provider/provider.dart';
import 'package:snaptune/sceens/albumscreen.dart';
import 'package:snaptune/sceens/main.home.dart';
import 'package:snaptune/sceens/navigator.visible.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<MusicModel> allSongs = [];
  List<MusicModel> findmusic = [];

  @override
  void initState() {
    super.initState();
    initializeSongs();
  }

  Future<void> initializeSongs() async {
    allSongs = await getAllSongs();
    findmusic = List.from(allSongs);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                height: 50,
                color: Colors.grey,
                child: TextField(
                  onChanged: searchMusic,
                  decoration: const InputDecoration(
                    hintText: 'What do you want to listen',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'All Songs',
                style: TextStyle(
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: findmusic.length,
                itemBuilder: (context, index) {
                  final music = findmusic[index];
                  return ListTile(
                    leading: QueryArtworkWidget(
                      id: music.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Image(
                        image: AssetImage('assets/images/leadingImage.png'),
                      ),
                    ),
                    title: Text(
                      music.name, // Use 'name' instead of 'songname'
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                    subtitle: Text(
                      music.artist,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                    trailing: IconButton(onPressed: (){
                        
                            }, icon: Icon(Icons.more_horiz)),
                    onTap: () {
                      context
                          .read<songModelProvider>()
                          .setId(allSongs[index].id);
                      context
                          .read<songModelProvider>()
                          .updateCurrentSong(findmusic[index]);

                      VisibilityNav.isvisible = true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlbumScreen(
                            songModel: findmusic[index],
                            audioPlayer: audioPlayer,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  searchMusic(String query) {
    final suggestion = allSongs.where((music) {
      final songname = music.name;
      
      final lowerCaseSongName = songname.toLowerCase();
      final input = query.toLowerCase();
      return lowerCaseSongName.contains(input);
    }).toList();

    setState(() {
      findmusic = suggestion;
    });
  }
}