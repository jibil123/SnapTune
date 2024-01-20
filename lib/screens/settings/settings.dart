import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snaptune/screens/settings/screens/about.dart';
import 'package:snaptune/screens/settings/screens/privacy.dart';
import 'package:snaptune/screens/settings/screens/terms.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding:const EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Column(
          children: [
             Row(
              children: [
                const Icon(
                  Icons.music_note,
                  size: 80,
                ),
                Text(
                  'Settings',
                 style: GoogleFonts.pacifico(fontSize: 50) 
                ),
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  // Row(
              //   children: [
              //     Icon(Icons.share,size: 40,),
              //     Text(' Share',style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic),),
              //   ],
              // ),
              // SizedBox(height: 20,),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx){
                    return const TermsConditions();
                  }
                 )
                );
                },
                child: Row(
                  children: [
                    const Icon(Icons.policy_outlined, size: 35),
                    const SizedBox(width: 10),
                    Text('Terms & Conditions',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 23, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
                  InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx){
                    return const PrivacyPolicy();
                  }
                 )
                );
                },
                child: Row(
                  children: [
                    const Icon(Icons.private_connectivity_outlined, size: 35),
                    const SizedBox(width: 10),
                    Text('Privacy & policy',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 23, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx){
                    return  const AboutScreen();
                  }
                 )
                );
                },
                child: Row(
                  children: [
                    const  Icon(Icons.info, size: 35),
                    const SizedBox(width: 10),
                    Text('About',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 23, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),   
              SizedBox(height:mediaquery.size.height *0.5),     
                 const  Text('Version 1.11.0')
               
                ],
              ),
            ),
            
          ],
        ),
      )),
    );
  }
}
