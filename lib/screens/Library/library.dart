// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:snaptune/db/songmodel/model.dart';
import 'package:snaptune/screens/Library/audioRecord/audioRecord.dart';
import 'package:snaptune/screens/Library/playlist/deletescreen.dart';
import 'package:snaptune/screens/Library/favorite/favourite.dart';
import 'package:snaptune/screens/Library/playlist/playlistscreen.dart';
import 'package:snaptune/db/db.functions/functions.dart';
import 'package:snaptune/screens/Library/recentlyplayed/recently.dart';
// import 'package:google_fonts/google_fonts.dart';

TextEditingController playListNameController = TextEditingController();

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
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
                  const Text('Your Library',
                      style: TextStyle(fontSize: 25, fontFamily: 'Pacifico')),
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
              SizedBox(height: mediaquery.size.height * 0.015),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AudioRecord()));
                },
                child: Container(
                  width: mediaquery.size.width * 0.85,
                  height: mediaquery.size.height * 0.2,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 136, 122, 122),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.record_voice_over_sharp, size: 80),
                          Text('Voice Recorder ',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ABeeZee')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      width: mediaquery.size.width * 0.41,
                      height: mediaquery.size.height * 0.17,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 116, 111, 111),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.favorite,
                                size: mediaquery.size.height * 0.07),
                            const Text('Favorite Songs',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ABeeZee')),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: mediaquery.size.width * 0.06),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RecentlyPlayed()));
                    },
                    child: Container(
                      width: mediaquery.size.width * 0.41,
                      height: mediaquery.size.height * 0.17,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 116, 111, 111),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child:const Padding(
                        padding:  EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Icon(Icons.music_note_outlined, size: 60),
                            Text('Recently Played',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ABeeZee')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mediaquery.size.height * 0.02,
              ),
              Expanded(
                child: FutureBuilder(
                  future: getAllPlaylists(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      // Handle the case where no data is available.
                      return const Text('No playlists available.');
                    } else {
                      // Data is available, proceed with building the GridView.
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 3 / 2,
                        ),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          PlaylistSongModel item = snapshot.data![index];
                          if (item == null) {
                            const Center(child: Text('Add Playlist'));
                            setState(() {});
                          }
                          return InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PlaylistSongs(id: item.key),
                            )),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 83, 77, 77),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.queue_music_rounded,
                                            size: 60,
                                          ),
                                          PopupMenuButton(
                                            color: Colors.black38,
                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (i) {
                                                            playListNameController
                                                                    .text =
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .name;
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Change Playlist name'),
                                                              content:
                                                                  TextField(
                                                                controller:
                                                                    playListNameController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                        hintText:
                                                                            'Enter new name'),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      // ignore: prefer_is_not_empty
                                                                      if (!playListNameController
                                                                          .text
                                                                          .isEmpty) {
                                                                        editPlaylistName(
                                                                            key:
                                                                                snapshot.data![index].key,
                                                                            newName: playListNameController.text);
                                                                        playListNameController
                                                                            .clear();
                                                                        setState(
                                                                            () {});
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        'Change name')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      playListNameController
                                                                          .clear();
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        'Cancel'))
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: const Text('Edit')),
                                                PopupMenuItem(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (i) {
                                                          return deleteDailog(
                                                              songkey: snapshot
                                                                  .data![index]
                                                                  .key);
                                                        }).then((value) {
                                                      setState(() {});
                                                    });
                                                  },
                                                  child: const Text('Dlete'),
                                                )
                                              ];
                                            },
                                          ),
                                        ]),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(item.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: mediaquery.size.height *
                                                  0.024,
                                              fontWeight: FontWeight.bold,fontFamily: 'ABeeZee')),
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
          title: const Text('Add Playlist'),
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
                if (playListNameController.text.isNotEmpty) {
                  addPlaylist(playListNameController.text, []);
                  Navigator.of(context).pop();
                  playListNameController.clear();
                  setState(() {});
                }
              },
              child: const Text('Add'),
            )
          ],
        );
      },
    );
  }
}
