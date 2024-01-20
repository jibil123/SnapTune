import 'package:flutter/material.dart';
import 'package:snaptune/db/db.functions/functions.dart';

// ignore: must_be_immutable, camel_case_types
class deleteDailog extends StatefulWidget {
  deleteDailog({super.key, required this.songkey});
  int songkey;

  @override
  State<deleteDailog> createState() => _deleteDailogState();
}

// ignore: camel_case_types
class _deleteDailogState extends State<deleteDailog> {
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: const Text('Delete File'),
      content: const Text('Are you sure to delete this playlist ?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              deletePlaylist(widget.songkey);
              Navigator.pop(context);
            },
            child: const Text('Delete'))
      ],
    );
  }
}