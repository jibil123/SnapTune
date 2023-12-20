import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
        child: Column(
          children: [
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
            ),
            SizedBox(height: 20,),
            Expanded(
              child: Container(
                child: GridView(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(15)),
                      
                    ),
                    Container(
                       decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(15),),
                    ),
                  ],
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
