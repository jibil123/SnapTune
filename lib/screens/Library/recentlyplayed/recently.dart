import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/db.functions/functions.dart';
import 'package:snaptune/db/songmodel/model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snaptune/screens/home/mainHome/main.home.dart';
import 'package:snaptune/screens/home/nowplaying/albumscreen.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({super.key});

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Recently played',
          style: GoogleFonts.abyssinicaSil(fontSize: 25),
        ),
      ),
      body: FutureBuilder<List<MusicModel>>(
          future: recentlyPlayedSongs(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No Recently Played Songs',
                  style: GoogleFonts.abyssinicaSil(fontSize: 25),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        onTap: () {
                          // ignore: avoid_single_cascade_in_expression_statements
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AlbumScreen(
                                    songModel: snapshot.data![index],
                                    audioPlayer: audioPlayer,
                                    allsong: snapshot.data!,
                                    index: index,
                                  )))
                            ..then((value) {
                              setState(() {});
                            });
                        },
                        leading: QueryArtworkWidget(
                          id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Image(
                            image: AssetImage('assets/images/leadingImage.png'),
                          ),
                        ),
                        title: Text(
                          snapshot.data![index]
                              .name, // Use 'name' instead of 'songname'
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        subtitle: Text(
                          snapshot.data![index].artist,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                showBottomSheets(
                                    context, snapshot.data![index]);
                              });
                            },
                            icon: Icon(Icons.more_horiz)));
                  });
            }
          }),
    );
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
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Remove From Favourite',
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
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
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Add to Favourite',
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
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
                      onPressed: () {
                        showAddToPlaylistBottomSheet(context, music);
                      },
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        deleteRecentSong(music.id);
                        setState(() {});
                        Navigator.pop(context);
                      },
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delte Recently Song',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const Icon(
                            Icons.delete,
                            size: 35,
                            color: Colors.black,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
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
}
