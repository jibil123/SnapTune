import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.music_note,
                  size: 80,
                ),
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            // Row(
            //   children: [
            //     Icon(Icons.share,size: 40,),
            //     Text(' Share',style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic),),
            //   ],
            // ),
            // SizedBox(height: 20,),
            InkWell(
              onTap: () {},
              child: Container(
                child: Row(
                  children: [
                    Icon(Icons.music_note_rounded, size: 40),
                    SizedBox(width: 10),
                    Text('Recently Played',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                child: Row(
                  children: [
                    Icon(Icons.private_connectivity_outlined, size: 40),
                    SizedBox(width: 10),
                    Text('Privacy & policy',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {},
              child: Container(
                child: Row(
                  children: [
                    Icon(Icons.policy_outlined, size: 40),
                    SizedBox(width: 10),
                    Text('Terms & Conditions',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {},
              child: Container(
                child: Row(
                  children: [
                    Icon(Icons.info, size: 40),
                    SizedBox(width: 10),
                    Text('About',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
