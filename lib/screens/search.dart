
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:snaptune/db/functions.dart';
import 'package:snaptune/db/model.dart';
import 'package:snaptune/provider/provider.dart';
import 'package:snaptune/screens/albumscreen.dart';
import 'package:snaptune/screens/main.home.dart';
import 'package:snaptune/screens/navigator.visible.dart';

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
                            ShowBottomSheet(context);
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
                            musicModel: findmusic[index],
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

  Future<void>ShowBottomSheet(BuildContext ctx)async{
    showModalBottomSheet(context: context, builder: (context1){
      return Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.brown,borderRadius: BorderRadius.circular(25)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:15,right: 15),
          child: Column(
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon:const Icon(Icons.arrow_downward,size: 40),),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add to Favourite Songs',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                  IconButton(onPressed: (){
          
                  }, icon: Icon(Icons.favorite,size: 30,)),
                ],
              ),
               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add to Playlist',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                  IconButton(onPressed: (){
          
                  }, icon:const Icon(Icons.library_add,size: 30,)),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('View in Album',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                  IconButton(onPressed: (){
          
                  }, icon:const Icon(Icons.album,size: 30,)),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}