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
                'Welcome to SnapTune,where music comes alive! . Immerse yourself in the world of music with SnapTune.Discover, stream, and enjoy your favorite tunes all in one place.Experience a new level of musicexploration with SnapTune . Curatedplaylists for every mood and occasion.Personalized recommendations basedon your music preferences.Unlimited access to a vast library of songs at your fingertips.Our mission is to make musican integral part of your daily life.Available on iOS and Android.Connect with other music lovers,share your favorite tracks, and discover new gems together.Users love SnapTune Here what theyre saying.Thank you for joining us on this musical adventure.Let the beats play on!'
                ,style: GoogleFonts.abyssinicaSil(
                fontSize: 25,)),
          ),
      )
    );
  }
}
