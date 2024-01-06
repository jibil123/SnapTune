import 'package:flutter/material.dart';
import 'package:snaptune/screens/Library/addplaylsit.dart';

class PlaylistSongs extends StatefulWidget {
  PlaylistSongs({super.key, required this.id});
  int id;

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return AddSongsToPlayList(
              id: widget.id,
            );
          })).then((value) {
            setState(() {});
          });
        },
        backgroundColor: Colors.amber,
        child: Icon(
          Icons.add,
          color: Colors.cyan,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('playlist Screen'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}