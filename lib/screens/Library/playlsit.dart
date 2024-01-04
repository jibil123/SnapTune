import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/functions.dart';
import 'package:snaptune/db/model.dart';
import 'package:snaptune/screens/albumscreen.dart';
import 'package:snaptune/screens/main.home.dart'; // Import your MusicModel

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late List<MusicModel> songs; // List to store songs

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  // Function to load songs from the database
  Future<void> loadSongs() async {
    songs = await getAllSongs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add to playlist'),
      ),
      body: songs != null
          ? ListView.builder(
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: QueryArtworkWidget(
                    id: songs[index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Image(
                        image: AssetImage('assets/images/leadingImage.png')),
                  ),
                  title: Text(
                    songs[index].name,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Text(
                    "${songs[index].artist}",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.playlist_add,
                        size: 40,
                      )),
                  // Add your desired functionality here
                  onTap: () {
                    // Perform action when a song is tapped
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AlbumScreen(
                            songModel: songs[index],
                            audioPlayer: audioPlayer,
                            allsong: songs)));
                  },
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
