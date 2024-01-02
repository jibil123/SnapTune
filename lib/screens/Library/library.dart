import 'package:flutter/material.dart';
import 'package:snaptune/screens/Library/favourite.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

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
          children: [const
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.music_note,
                  size: 40,
                ),
                Text(
                  'Your Library',
                  style: TextStyle(
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.add,
                  size: 35,
                ),
              ],
            ),const
            SizedBox(
              height: 20,
            ),
            Expanded(
              child:  GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                ),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FavoriteSongs()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 214, 83, 74),
                          borderRadius: BorderRadius.circular(15)),
                      child:const Padding(
                        padding: EdgeInsets.only(left: 10,top: 5),
                        child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.favorite,size: 70),
                            Text('Favourite Songs',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 214, 83, 74),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child:const Padding(
                        padding: EdgeInsets.only(left: 10,top: 5),
                        child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.record_voice_over_sharp,size: 70),
                            Text('Voice Record',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
