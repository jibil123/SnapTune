import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/db.functions/functions.dart';

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
      body: FutureBuilder(
          future: getSongsFromRcent(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
              ListTile(
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
                      trailing:Icon(Icons.play_circle_fill_outlined)
              );
            });
          }),
    );
  }
}
