import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: 
      Padding(
        padding: const EdgeInsets.only(top: 10,left: 15,right: 15),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.music_note,size: 80,),
                Text('Profile',style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.share,size: 40,),
                Text(' Share',style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic),),
              ],
            ),
            SizedBox(height: 20,),
             Row(
              children: [
                Icon(Icons.timer,size: 40,),
                Text(' Sleeper Timer',style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic),),
              ],
            ),
            SizedBox(height: 20,),
             Row(
              children: [
                Icon(Icons.private_connectivity_outlined,size: 40,),
                Text(' Privacy & Policy',style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic)),
              ],
            ),
            SizedBox(height: 20),
             Row(
              children: [
                Icon(Icons.policy,size: 40,),
                Text(' Terms And Conditions',style: TextStyle(fontSize: 30)),
              ],
            ),
            SizedBox(height: 20),
             Row(
              children: [
                Icon(Icons.info_outline,size: 40,),
                Text(' About',style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic)),
              ],
            ),
          ],
        ),
      )
      ),
    );
  }
}