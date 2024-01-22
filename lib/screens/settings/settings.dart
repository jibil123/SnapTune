import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
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
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.music_note,
                  size: 80,
                ),
                Text('Settings',
                    style: TextStyle(fontSize: 50, fontFamily: 'Pacifico')),
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
                  InkWell(
                    onTap: () {
                      Share.share('Get SnapTune from the Amazon Appstore. Check it out - https://www.amazon.com/dp/B0CSWNC3H3/ref=apps_sf_sta');
                    },
                    child:const Row(
                      children: [
                        Icon(
                          Icons.share,
                          size: 35,
                        ),
                        SizedBox(width: 5),
                        Text(
                          ' Share',
                          style: TextStyle(
                              fontSize: 23,fontFamily: 'ABeeZee',fontWeight: FontWeight.bold, ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const TermsConditions();
                      }));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.policy_outlined, size: 35),
                        SizedBox(width: 10),
                        Text('Terms & Conditions',
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ABeeZee')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const PrivacyPolicy();
                      }));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.private_connectivity_outlined, size: 35),
                        SizedBox(width: 10),
                        Text('Privacy & policy',
                            style: TextStyle(
                                fontSize: 23,
                                fontFamily: 'ABeeZee',
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const AboutScreen();
                      }));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.info, size: 35),
                        SizedBox(width: 10),
                        Text('About',
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ABeeZee')),
                      ],
                    ),
                  ),
                  SizedBox(height: mediaquery.size.height * 0.5),
                  const Text('Version 1.11.0')
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
