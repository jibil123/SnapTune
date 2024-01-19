import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:snaptune/db/db.functions/functions.dart';
import 'package:snaptune/db/songmodel/model.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:snaptune/provider/provider.dart';
import 'package:snaptune/screens/home/nowplaying/artworkFunction/artwork.dart';

// ignore: must_be_immutable
class AlbumScreen extends StatefulWidget {
  AlbumScreen({
    Key? key,
    required this.songModel,
    required this.audioPlayer,
    required this.allsong,
    required this.index,
  }) : super(key: key);

  MusicModel songModel;
  final AudioPlayer audioPlayer;
  final List<MusicModel> allsong;
  int index;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = false;
  bool _isShuffling = false;
  bool _isLooping = false; // Added loop flag
  List<MusicModel> shuffledPlaylist = [];

  @override
  void initState() {
    super.initState();
    playsong();
    showLikedSongs();
    ifLickedSongs();
    
    widget.audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        playNextSong();
      }
    });
  }



void showAddToPlaylistBottomSheet(BuildContext context) async {
  List<PlaylistSongModel> playlists = await getAllPlaylists();

  if (playlists.isEmpty) {
    // No playlists available
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No playlists available'),
      ),
    );
    return;
  }

  // ignore: use_build_context_synchronously
  await  showModalBottomSheet(
    context: context,
    builder: (context) {
      // ignore: sized_box_for_whitespace
      return Container(
        height: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,  
          children: [
            ListTile(
              title:const Text('Add to Playlist',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold ),),
              onTap: () {},
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(playlists[index].name,style:const TextStyle(fontWeight: FontWeight.w500 ,fontSize: 20 ),),
                    onTap: () async {
                      bool songAlreadyInPlaylist = await ifSongContain(
                        widget.songModel,
                        playlists[index].key,
                      );

                      if (songAlreadyInPlaylist) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Song already in the playlist'),
                          ),
                        );
                      } else {
                        await addSongsToPlaylist(
                          widget.songModel,
                          playlists[index].key,
                        );

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Song added to playlist'),
                          ),
                        );
                      }

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}


  void playNextSong() {
    int currentIndex = widget.allsong.indexOf(widget.songModel);

    if (_isLooping) {
 
      widget.audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(widget.songModel.uri),
      ));
    }
     else {
      int nextIndex;

      if (_isShuffling) {
        nextIndex = shuffledPlaylist.indexOf(widget.songModel) + 1;
        if (nextIndex >= shuffledPlaylist.length) {
          shuffledPlaylist = shuffleSongs(widget.allsong);
          nextIndex = 0;
        }
        widget.audioPlayer.setAudioSource(AudioSource.uri(
          Uri.parse(shuffledPlaylist[nextIndex].uri),
        ));
      } else {
        nextIndex = (currentIndex + 1) % widget.allsong.length;
        widget.audioPlayer.setAudioSource(AudioSource.uri(
          Uri.parse(widget.allsong[nextIndex].uri),
        ));
      }

      updateCurrentSong(widget.allsong[nextIndex]);
    }

    widget.audioPlayer.play();
    setState(() {
      _isPlaying = true;
    });
  }

  void playPreviousSong() {
    int currentIndex = widget.allsong.indexOf(widget.songModel);

    if (_isLooping) {
      // If looping is enabled, play the same song again
      widget.audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(widget.songModel.uri),
      ));
    } else {
      // If not looping, proceed with the previous song logic
      int previousIndex;

      if (_isShuffling) {
        previousIndex = shuffledPlaylist.indexOf(widget.songModel) - 1;
        if (previousIndex < 0) {
          shuffledPlaylist = shuffleSongs(widget.allsong);
          previousIndex = shuffledPlaylist.length - 1;
        }
        widget.audioPlayer.setAudioSource(AudioSource.uri(
          Uri.parse(shuffledPlaylist[previousIndex].uri),
        ));
      } else {

        previousIndex = (currentIndex - 1 + widget.allsong.length) % widget.allsong.length;
        widget.audioPlayer.setAudioSource(AudioSource.uri(
          Uri.parse(widget.allsong[previousIndex].uri),
        ));
      }

      updateCurrentSong(widget.allsong[previousIndex]);
    }

    widget.audioPlayer.play();
    setState(() {
      _isPlaying = true;
    });
  }

  void playsong()async {
    await addRecentlyPlayed(widget.allsong![widget.index].id);
    try {
      widget.audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(widget.songModel.uri),
      ));
      widget.audioPlayer.play();
      _isPlaying = true;
    } on Exception {
      // ignore: avoid_print
      print('Error playing song');
    }

    // Listen for changes in duration and position
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

  List<MusicModel> shuffleSongs(List<MusicModel> songs) {
    List<MusicModel> shuffledSongs = List.from(songs);
    shuffledSongs.shuffle(Random());
    return shuffledSongs;
  }

  void updateCurrentSong(MusicModel newSongModel) {
  context.read<SongModelProvider>().setId(newSongModel.id);
  setState(() {
    widget.songModel = newSongModel;
  });
}



  void changetoseconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
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
                style:  GoogleFonts.pacifico( 
                  fontWeight: FontWeight.bold,
                        fontSize: mediaquery.size.height * 0.050,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: mediaquery.size.height * 0.07),
              child: const Center(child: ArtWorkWidget()),
            ),
            SizedBox(
              height: mediaquery.size.height * 0.09,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ignore: sized_box_for_whitespace
                Container(
                  width: mediaquery.size.width * 0.65,
                  child: MarqueeText(
                    speed: 20,
                    text: TextSpan(
                      text: widget.songModel.name,
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: mediaquery.size.height * 0.045, 
                      ),
                    ),
                  ),
                ),
                favSongs.contains(widget.songModel.id)
                    ? IconButton(
                        onPressed: () {
                          removeLikedSongs(widget.songModel.id);
                          ifLickedSongs();
                          setState(() {});
                        }, 
                        icon:  Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: mediaquery.size.height*0.04,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          addLikedSongs(widget.songModel.id);
                          ifLickedSongs();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                          size: mediaquery.size.height*0.04,
                        ),
                      )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ignore: sized_box_for_whitespace
                Container(
                  width: mediaquery.size.width * 0.60,
                  child: MarqueeText(
                    speed: 20,
                    text: TextSpan(
                      text: widget.songModel.artist.toString() == "<unknown>"
                          ? "<unknown Artist>"
                          : widget.songModel.artist.toString(),
                      style: GoogleFonts.sevillana(
                        fontSize: mediaquery.size.height * 0.025,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showAddToPlaylistBottomSheet(context);
                  },
                  icon: Icon(
                    Icons.library_add,
                    size: mediaquery.size.height * 0.04,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(_position.toString().split(".")[0]),
                Expanded(
                  child: Slider(
                    min: const Duration(microseconds: 0).inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        changetoseconds(value.toInt());
                        value = value;
                      });
                    },
                  ),
                ),
                Text(_duration.toString().split(".")[0]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isShuffling = !_isShuffling;
                      if (_isShuffling) {
                        shuffledPlaylist = shuffleSongs(widget.allsong);
                      }
                    });
                  },
                  icon: Icon(
                    Icons.shuffle,
                    size: mediaquery.size.height * 0.04,
                    color: _isShuffling ? Colors.blue : Colors.white,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: playPreviousSong,
                      icon: Icon(
                        Icons.skip_previous,
                        size: mediaquery.size.height * 0.06,
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
                      icon: Icon(
                        _isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: mediaquery.size.height * 0.07,
                      ),
                    ),
                    IconButton(
                      onPressed: playNextSong,
                      icon: Icon(
                        Icons.skip_next,
                        size: mediaquery.size.height * 0.06,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isLooping = !_isLooping;
                    });
                  },
                  icon: Icon(
                    Icons.repeat,
                    size: mediaquery.size.height * 0.04,
                    color: _isLooping ? Colors.blue : Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
