import 'package:flutter/material.dart';
import 'package:snaptune/db/songmodel/model.dart';
import 'package:snaptune/screens/Library/audioRecord/audioRecord.dart';
import 'package:snaptune/screens/Library/playlist/deletescreen.dart';
import 'package:snaptune/screens/Library/favorite/favourite.dart';
import 'package:snaptune/screens/Library/playlist/playlistscreen.dart';
import 'package:snaptune/db/db.functions/functions.dart';

TextEditingController playListNameController = TextEditingController();

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    var _mediaquery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.music_note,
                    size: 40,
                  ),
                  const Text(
                    'Your Library',
                    style: TextStyle(
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      size: 35,
                    ),
                    onPressed: () {
                  
                      showAddItemDialog(context);
                   
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                   
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoriteSongs(),
                        ),
                      );
                    },
                    child: Container(
                      width: _mediaquery.size.width * 0.41,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 214, 83, 74),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.favorite, size: 70),
                            Text(
                              'Favourite Songs',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: _mediaquery.size.width * 0.05),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AudioRecord()))
                        ..then((value) {
                          setState(() {});
                        });
                    },
                    child: Container(
                      width: _mediaquery.size.width * 0.41,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 214, 83, 74),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.record_voice_over_sharp, size: 70),
                            Text(
                              'Voice Record',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _mediaquery.size.height * 0.02,
              ),
              Expanded(
                child: FutureBuilder(
                  future: getAllPlaylists(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {                  
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      // Handle the case where no data is available.
                      return Text('No playlists available.');
                    } else {
                      // Data is available, proceed with building the GridView.
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          PlaylistSongModel item = snapshot.data![index];
                          return GestureDetector(
                            
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PlaylistSongs(
                                id: item.key,
                              ),
                            )),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 214, 83, 74),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                         Icon(
                                          Icons.music_note,
                                          size: 70,
                                        ),
                                        SizedBox(width: 25),
                                          PopupMenuButton(
                                            color: Colors.black38,
                                            icon: Icon(Icons.more_vert),
                                            itemBuilder: (context) {
                                             return[
                                              PopupMenuItem(
                                                onTap: () {
                                                  showDialog(context: context, builder:(i) {
                                                    return deleteDailog(songkey: snapshot.data![index].key);
                                                  }
                                                ).then((value) {
                                                  setState(() {});
                                                });
                                              },
                                                child: Text('Dlete'),)
                                             ];
                                            },
                                            ),
                                            
                                      ],
                                    ),
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAddItemDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Playlist'),
          content: TextField(
            controller: playListNameController,
            decoration: const InputDecoration(
              hintText: 'Enter playlist name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                addPlaylist(playListNameController.text, []);
                Navigator.of(context).pop();
                playListNameController.clear();
                setState(() {
                  
                });
              },
              child: const Text('Add'),
            )
          ],
        );
      },
    );

  }
}
