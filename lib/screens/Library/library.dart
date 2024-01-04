import 'package:flutter/material.dart';
import 'package:snaptune/screens/Library/audioRecord.dart';
import 'package:snaptune/screens/Library/favourite.dart';
import 'package:snaptune/screens/Library/playlsit.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Map<String, dynamic>> items = [];

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
                    icon:const Icon(
                       Icons.add,
                      size: 35,
                    ),
                    onPressed: () => showAddItemDialog(context),
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
                           width:_mediaquery.size.width *0.41 , 
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
                      SizedBox(width:  _mediaquery.size.width *0.05),
                      GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AudioRecord()));
                    },
                    child: Container(
                      width:_mediaquery.size.width *0.41,
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
                SizedBox(height: _mediaquery.size.height*0.02,),
                  
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // Handle the tap on the playlist item
                        // You can navigate to a specific screen or perform any other action
                      },
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PlaylistScreen()))
                        ,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 83, 74),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.music_note, // You can customize the icon
                                  size: 70,
                                ),
                                Text(
                                  items[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
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
    String newItemName = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Playlist'),
          content: TextField(
            onChanged: (value) {
              newItemName = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter playlist name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newItemName.isNotEmpty) {
                  setState(() {
                    items.add({'name': newItemName});
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}


