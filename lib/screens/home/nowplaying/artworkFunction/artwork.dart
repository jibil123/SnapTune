
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:snaptune/provider/provider.dart';

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    return QueryArtworkWidget(
      key: ValueKey<int>(context.watch<SongModelProvider>().id),
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      nullArtworkWidget: Icon(
        Icons.music_note,
        size: mediaquery.size.height * 0.35,
      ),
      artworkHeight: mediaquery.size.height * 0.35,
      artworkWidth: mediaquery.size.height * 0.35,
      artworkFit: BoxFit.cover,
    );
  }
}
