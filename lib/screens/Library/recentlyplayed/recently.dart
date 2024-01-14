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
        title: Text('Recently played'),
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
                                deleteRecentSong(snapshot.data![index].id);
                              });
                            },
                            icon: Icon(Icons.delete)));
                  });
            }
          }),
    );
  }
}
