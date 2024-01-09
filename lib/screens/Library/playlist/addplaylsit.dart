import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/db.functions/functions.dart';

class AddSongsToPlayList extends StatefulWidget {
  AddSongsToPlayList({super.key, required this.id});
  int id;

  @override
  State<AddSongsToPlayList> createState() => _AddSongsToPlayListState();
}

class _AddSongsToPlayListState extends State<AddSongsToPlayList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add songs to Plsylist'),
      ),
      body: FutureBuilder(
          future: getAllSongs(),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  return ListTile(
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
                    trailing:
                        IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                  );
                }));
          }),
    );
  }
}
