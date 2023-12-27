import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:snaptune/db/model.dart';
import 'package:snaptune/provider/provider.dart';

class AlbumScreen extends StatefulWidget {
  AlbumScreen({super.key, required this.songModel, required this.audioPlayer});
  final MusicModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    playsong();
  }

  void playsong() {
    try {
      widget.audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(widget.songModel.uri),
      ));
      widget.audioPlayer.play();
      _isPlaying = true;
    } on Exception {
      print('object');
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _mediaquery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              'SnapTune',
              style: TextStyle(
                  fontSize: _mediaquery.size.height * 0.05,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            )),
            Padding(
              padding: EdgeInsets.only(top: _mediaquery.size.height * 0.07),
              child:const Center(
                  child:  ArtWorkWidget()),
            ),
            SizedBox(
              height: _mediaquery.size.height * 0.09,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: _mediaquery.size.width * 0.7,
                  child: Text(
                    widget.songModel.name,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        fontSize: _mediaquery.size.height * 0.04,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(Icons.favorite, size: _mediaquery.size.height * 0.05),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: _mediaquery.size.width * 0.7,
                  child: Text(
                    widget.songModel.artist.toString() == "<unknown>"
                        ? "<unknown Artist>"
                        : widget.songModel.artist.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: _mediaquery.size.height * 0.025),
                  ),
                ),
                Icon(
                  Icons.library_add,
                  size: _mediaquery.size.height * 0.05,
                ),
              ],
            ),
            Row(
              children: [
                Text(_position.toString().split(".")[0]),
                Expanded(
                    child: Slider(
                        min: Duration(microseconds: 0).inSeconds.toDouble(),
                        value: _position.inSeconds.toDouble(),
                        max: _duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            changetoseconds(value.toInt());
                            value = value;
                          });
                        })),
                Text(_duration.toString().split(".")[0]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shuffle),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.skip_previous,
                        size: _mediaquery.size.height * 0.07,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_isPlaying) {
                            widget.audioPlayer.pause();
                          } else {
                            widget.audioPlayer.play();
                          }
                          _isPlaying = !_isPlaying;
                        });
                      },
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                          size: _mediaquery.size.height * 0.08),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.skip_next,
                        size: _mediaquery.size.height * 0.07,
                      ),
                    )
                  ],
                ),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.restart_alt_outlined)),
              ],
            )
          ],
        ),
      ),
    );
  }

  void changetoseconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
                    id: context.watch<songModelProvider>().id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Icon(Icons.music_note, size: 330,),
                    artworkHeight: 330,
                    artworkWidth: 330,
                    artworkFit: BoxFit.cover,
                  );
  }
}
