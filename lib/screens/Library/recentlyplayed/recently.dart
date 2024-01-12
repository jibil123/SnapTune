import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/db.functions/functions.dart';
import 'package:snaptune/db/songmodel/model.dart';

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
            return const Center(
              child: Text(
                'no recently songs ',
              ),
            );
          }else{
            return ListView.builder(           
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
              return
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
                      trailing:IconButton(onPressed: (){
                        
                        setState(() {
                          deleteRecentSong(snapshot.data![index].id);
                        });
                      }, icon: Icon(Icons.delete))
              );
            });
          }
          }),
    );
  }
}
