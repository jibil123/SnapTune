import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:snaptune/db/functions.dart';
import 'package:snaptune/db/model.dart';
import 'package:snaptune/provider/provider.dart';
import 'package:marquee_text/marquee_text.dart';

class AlbumScreen extends StatefulWidget {
  AlbumScreen({
    Key? key,
    required this.songModel,
    required this.audioPlayer,
  }) : super(key: key);

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

  @override
  void dispose() {
    // Ensure to dispose of the audio player and cancel subscriptions.
    widget.audioPlayer.dispose();
    super.dispose();
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
      if (mounted) {
        setState(() {
          _duration = d!;
        });
      }
    });
    widget.audioPlayer.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: _mediaquery.size.height * 0.07),
              child: const Center(child: ArtWorkWidget()),
            ),
            SizedBox(
              height: _mediaquery.size.height * 0.09,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: _mediaquery.size.width * 0.7,
                  child: MarqueeText(
                    text: TextSpan(
                      text: widget.songModel.name,
                      style: GoogleFonts.dmSerifDisplay(
                          fontSize: _mediaquery.size.height * 0.050),
                    ),
                  ),
                ),
                Container(
                    child: favSongs.contains(widget.songModel.id)
                        ? IconButton(
                            onPressed: () {
                              removeLikedSongs(widget.songModel.id);
                              ifLickedSongs();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 35,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              addLikedSongs(widget.songModel.id);
                              ifLickedSongs();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 35,
                            ),
                          ))
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: _mediaquery.size.width * 0.71,
                  child: MarqueeText(
                    speed: 20,
                    text: TextSpan(
                      text: widget.songModel.artist.toString() == "<unknown>"
                          ? "<unknown Artist>"
                          : widget.songModel.artist.toString(),
                      style: GoogleFonts.sevillana(
                          fontSize: _mediaquery.size.height * 0.025),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.library_add,
                    size: _mediaquery.size.height * 0.04,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(_position.toString().split(".")[0]),
                Expanded(
                    child: Slider(
                        min: const Duration(microseconds: 0)
                            .inSeconds
                            .toDouble(),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon:
                      Icon(Icons.shuffle, size: _mediaquery.size.height * 0.04),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.skip_previous,
                        size: _mediaquery.size.height * 0.06,
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
                          size: _mediaquery.size.height * 0.07),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.skip_next,
                        size: _mediaquery.size.height * 0.06,
                      ),
                    )
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.restart_alt_outlined,
                      size: _mediaquery.size.height * 0.04),
                ),
              ],
            ),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<songModelProvider>().id,
      type: ArtworkType.AUDIO,
      nullArtworkWidget: const Icon(
        Icons.music_note,
        size: 320,
      ),
      artworkHeight: 320,
      artworkWidth: 330,
      artworkFit: BoxFit.cover,
    );
  }
}
