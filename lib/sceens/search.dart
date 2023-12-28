import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:snaptune/db/functions.dart';
import 'package:snaptune/db/model.dart';
import 'package:snaptune/provider/provider.dart';
import 'package:snaptune/sceens/albumscreen.dart';
import 'package:snaptune/sceens/main.home.dart';
import 'package:snaptune/sceens/navigator.visible.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              color: Colors.grey,
              child: TextField(
                decoration: InputDecoration(
                   hintText: 'What do you want to litsen',
                   border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text('All Songs',style: TextStyle(fontSize: 28,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
            ),
             Expanded(
                  child: FutureBuilder<List<MusicModel>>(
                      future: getAllSongs(),
                      builder: (context, item) {
                        if (item.data == null) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (item.data!.isEmpty) {
                          return Text('song not found');
                        }
                        return ListView.builder(
                          itemBuilder: (context, index) => ListTile(
                            leading: QueryArtworkWidget(
                              id: item.data![index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Image(image: AssetImage('assets/images/leadingImage.png')),
                            ),
                            title: Text(item.data![index].name),
                            subtitle: Text("${item.data![index].artist}"),
                            trailing: Icon(Icons.more_horiz),
                            onTap: () {
                              context
                                  .read<songModelProvider>()
                                  .setId(item.data![index].id);
                              VisibilityNav.isvisible = true;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlbumScreen(
                                            songModel: item.data![index],
                                            audioPlayer: audioPlayer,
                                          )));
                            },
                          ),
                          itemCount: item.data!.length,
                        );
                  }
                  )),
          ],
        ),
      ),
    );
  }
}