import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:snaptune/db/db.functions/functions.dart';
import 'package:snaptune/screens/home/nowplaying/albumscreen.dart';
import 'package:snaptune/screens/home/main.home.dart';

class FavoriteSongs extends StatefulWidget {
  const FavoriteSongs({super.key});

  @override
  State<FavoriteSongs> createState() => _FavoriteSongsState();
}

class _FavoriteSongsState extends State<FavoriteSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Enjoy Music',
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Liked Songs",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Expanded(
                child: FutureBuilder(
                    future: showLikedSongs(),
                    builder: (context, items) {
                      if (items.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (items.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "Add Favourite Songs",
                            style: GoogleFonts.abyssinicaSil(fontSize: 30)
                          ),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: items.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: QueryArtworkWidget(
                                  id: items.data![index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Image(
                                    image: AssetImage(
                                        'assets/images/leadingImage.png'),
                                  ),
                                ),
                                title: Text(
                                  items.data![index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                ),
                                subtitle: Text(
                                  items.data![index].artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                ),
                                trailing: favSongs
                                        .contains(items.data![index].id)
                                    ? IconButton(
                                        onPressed: () {
                                          removeLikedSongs(
                                              items.data![index].id);
                                          ifLickedSongs();
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          addLikedSongs(items.data![index].id);
                                          ifLickedSongs();
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                      ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AlbumScreen(
                                            songModel: items.data![index],
                                            audioPlayer: audioPlayer,
                                            allsong: items.data!,
                                          )));
                                },
                              );
                            });
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
