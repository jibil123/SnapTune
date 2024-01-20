import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/db.functions/functions.dart';
import 'package:snaptune/db/songmodel/model.dart';
// ignore: must_be_immutable
class AddSongsToPlayList extends StatefulWidget {
  AddSongsToPlayList({super.key, required this.id});
  int id;

  @override
  State<AddSongsToPlayList> createState() => _AddSongsToPlayListState();
}

class _AddSongsToPlayListState extends State<AddSongsToPlayList> {
  late Future<List<MusicModel>> songsFuture;

  @override
  void initState() {
    super.initState();
    songsFuture = getAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const Text('Add songs to Playlist'),
      ),
      body: FutureBuilder(
        future: songsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Playlist found'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: QueryArtworkWidget(
                  id: snapshot.data![index].id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: const Image(
                    image: AssetImage('assets/images/leadingImage.png'),
                  ),
                ),
                title: Text(
                  snapshot.data![index].name,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                subtitle: Text(
                  snapshot.data![index].artist,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                trailing: _buildTrailingButton(snapshot.data![index]),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTrailingButton(MusicModel song) {
    return FutureBuilder<bool>(
      future: ifSongContain(song, widget.id ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.error, color: Colors.red);
        }

        bool songIsInPlaylist = snapshot.data ?? false;

        return IconButton(
          onPressed: () async {
            if (songIsInPlaylist) {
              await removeSongFromPlaylist(widget.id, song.id);
            } else {
              await addSongsToPlaylist(song, widget.id);
            }

            await getAllSongsToPlaylst(widget.id);
            setState(() {});
          },
          icon: Icon(
            songIsInPlaylist ? Icons.remove : Icons.add,
            color: songIsInPlaylist ? Colors.red : Colors.white,
          ),
        );
      },
    );
  }
}
