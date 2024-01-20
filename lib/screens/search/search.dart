import 'dart:async';

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:snaptune/db/db.functions/functions.dart';
import 'package:snaptune/db/songmodel/model.dart';
import 'package:snaptune/provider/provider.dart';
import 'package:snaptune/screens/home/nowplaying/albumscreen.dart';
import 'package:snaptune/screens/home/mainHome/main.home.dart';

class SearchScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
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

  void showAddToPlaylistBottomSheet(
      BuildContext context, MusicModel music) async {
    List<PlaylistSongModel> playlists = await getAllPlaylists();

    if (playlists.isEmpty) {
      // No playlists available
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No playlists available'),
        ),
      );
      return;
    }

    // ignore: use_build_context_synchronously
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        // ignore: sized_box_for_whitespace
        return Container(
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'Add to Playlist',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                onTap: () {},
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        playlists[index].name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      onTap: () async {
                        bool songAlreadyInPlaylist = await ifSongContain(
                          music,
                          playlists[index].key,
                        );

                        if (songAlreadyInPlaylist) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Song already in the playlist'),
                            ),
                          );
                        } else {
                          await addSongsToPlaylist(
                            music,
                            playlists[index].key,
                          );

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Song added to playlist'),
                            ),
                          );
                        }

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var mediaquery = MediaQuery.of(context);
    return Scaffold(
      
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 5),
              child: Row(
                children: [
                  const Icon(Icons.music_note, size: 40),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Search',
                      style: GoogleFonts.aBeeZee(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, top: 10, right: 15, bottom: 10),
              child: Container(
                height: 50,
                color: Colors.grey,
                child: TextField(
                  onChanged: searchMusic,
                  decoration: const InputDecoration(
                    hintText: 'What do you want to Listen',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: findmusic.isEmpty
                  ? Center(
                      child: Text('Songs Not Found',
                          style: GoogleFonts.abyssinicaSil(fontSize: 25)),
                    )
                  : ListView.builder(
                      itemCount: findmusic.length,
                      itemBuilder: (context, index) {
                        final music = findmusic[index];
                        return ListTile(
                          leading: QueryArtworkWidget(
                            id: music.id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Image(
                              image:
                                  AssetImage('assets/images/leadingImage.png'),
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
                                showBottomSheets(context, music, index);
                              },
                              icon: const Icon(Icons.more_horiz)),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            context 
                                .read<SongModelProvider>()
                                .setId(findmusic[index].id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AlbumScreen(
                                  songModel: findmusic[index],
                                  audioPlayer: audioPlayer,
                                  allsong: allSongs,
                                  index: index,
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

  showBottomSheets(BuildContext ctx, MusicModel music, int index) {
    var mediaquery = MediaQuery.of(context);
    showModalBottomSheet(
        context: ctx,
        builder: (context1) {
          return Container(
            height: mediaquery.size.height * 0.27,
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
                    icon:  Icon(
                      Icons.arrow_downward,
                      size:  mediaquery.size.height * 0.05,                    
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
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Remove From Favourite',
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: mediaquery.size.height * 0.03,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                 Icon(
                                  Icons.favorite,
                                  color: Colors.black,
                                  size: mediaquery.size.height * 0.04, 
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
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Add to Favourite',
                                  style: GoogleFonts.aBeeZee(
                                      fontSize:mediaquery.size.height * 0.03,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ), 
                                 Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                  size: mediaquery.size.height * 0.04,
                                ),
                              ],
                            ),
                          ),
                  ),
                  IconButton(
                      onPressed: () {
                        showAddToPlaylistBottomSheet(context, music);
                      },
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Add to Playlist',
                              style: GoogleFonts.aBeeZee(
                                  fontSize:mediaquery.size.height * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                            Icon(
                            Icons.library_add_outlined,
                            size: mediaquery.size.height * 0.04,
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
                                  index: index,
                                )
                              )
                            );
                      },
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('View in Album',
                              style: GoogleFonts.aBeeZee(
                                  fontSize : mediaquery.size.height * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                           Icon(
                            Icons.album_rounded,
                            size: mediaquery.size.height * 0.04, 
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
