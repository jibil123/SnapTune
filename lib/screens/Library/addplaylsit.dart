import 'package:flutter/material.dart';

class AddSongsToPlayList extends StatefulWidget {
  AddSongsToPlayList({super.key, required this.id});
  int id;

  @override
  State<AddSongsToPlayList> createState() => _AddSongsToPlayListState();
}

class _AddSongsToPlayListState extends State<AddSongsToPlayList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add songs to Plsylist'),
      ),
    );
  }
}