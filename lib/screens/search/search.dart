import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:snaptune/db/functions.dart';
import 'package:snaptune/db/model.dart';
import 'package:snaptune/provider/provider.dart';
import 'package:snaptune/screens/albumscreen.dart';
import 'package:snaptune/screens/main.home.dart';
import 'package:snaptune/screens/navigator.visible.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

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
    var _mediaquery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(12),
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
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('All Songs',
                  style: GoogleFonts.aBeeZee(
                      fontSize: 22.5, fontWeight: FontWeight.bold)),
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
                    trailing: IconButton(
                        onPressed: () {
                          showBottomSheets(context, music);
                        },
                        icon: const Icon(Icons.more_horiz)),
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
                            allsong:allSongs,
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

  showBottomSheets(BuildContext ctx, MusicModel music) {
    var mediaquery = MediaQuery.of(context);
    showModalBottomSheet(
        context: ctx,
        builder: (context1) {
          return Container(
            height: mediaquery.size.height * 0.25,
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 214, 203, 203),
                borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(
                      Icons.arrow_downward,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    child: favSongs.contains(music.id)
                        ? IconButton(
                            onPressed: () {
                              removeLikedSongs(music.id);
                              ifLickedSongs();
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            icon: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Remove From Favourite',
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),),
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.black,
                                  size: 35,
                                ),
                              ],
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              addLikedSongs(music.id);
                              ifLickedSongs();
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            icon: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text('Add to Favourite',
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),),
                                const Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                  size: 35,
                                ),
                              ],
                            ),
                          ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text('Add to Playlist',
                      style: GoogleFonts.aBeeZee(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                          const Icon(
                            Icons.library_add_outlined,
                            size: 35,
                            color: Colors.black,
                          ),
                        ],
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AlbumScreen(
                                songModel: music,
                                audioPlayer: audioPlayer,
                                allsong: allSongs,
                                )));
                      },
                      icon: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text('View in Album',
                      style: GoogleFonts.aBeeZee(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                          const Icon(
                            Icons.album_rounded,
                            size: 35,
                            color: Colors.black,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          );
        });
  }
}
