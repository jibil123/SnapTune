import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/db.functions/functions.dart';
import 'package:snaptune/screens/Library/playlist/addplaylsit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snaptune/screens/home/mainHome/main.home.dart';
import 'package:snaptune/screens/home/nowplaying/albumscreen.dart';

class PlaylistSongs extends StatefulWidget {
  PlaylistSongs({super.key, required this.id});
  int id;

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('playlist Screen'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return AddSongsToPlayList(
                    id: widget.id,
                  );
                })).then((value) {
                  setState(() {});
                });
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future: getAllSongsToPlaylst(widget.id),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Add Playlist Songs',style: GoogleFonts.abyssinicaSil(fontSize: 25),
                  ),
                );
              }
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
                          removeSongFromPlaylist(
                              widget.id, snapshot.data![index].id);
                          setState(() {});
                        },
                        icon: Icon(Icons.delete)),
                  );
                });
          }),
    );
  }
}
