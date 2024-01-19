import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:const Text('About')),
        body: Padding(
          padding:const EdgeInsets.all(20), 
          child:  SingleChildScrollView(
            child: Text(
                '''About SnapTune

SnapTune is your ultimate offline musical companion, designed to revolutionize the way you experience and manage your audio library. Dive into a seamless audio journey as SnapTune empowers you to explore and enjoy every audio file stored in your device's internal storage.

Key Features:

1-Audio Exploration:

SnapTune grants you access to all audio files on your device, ensuring that every song and audio clip is just a tap away.
 
2-Favorite Songs:

Curate your own musical haven by marking your favorite songs with a simple touch. Create a personalized collection that resonates with your unique taste.

3-Playlist Creation:

Tailor your listening experience by crafting playlists that suit every mood and occasion. SnapTune lets you effortlessly create and add songs to playlists for a customized musical journey.

4-Recently Played:

Never lose track of the tunes that resonate with you the most. SnapTune keeps a record of your recently played tracks, allowing you to revisit your favorite sounds with ease.

5-Audio Recording and Playback:

Unleash your creativity with SnapTune's audio recording feature. Capture your own sounds, voice memos, or impromptu musical moments, and play them back whenever you desire.

6-Search Songs:

Finding your favorite tracks is a breeze with SnapTune's robust search functionality. Quickly locate any song within your vast music collection, making your exploration effortless.'''

                ,style: GoogleFonts.abyssinicaSil(
                fontSize: 20)),
          ),
      )
    );
  }
}
