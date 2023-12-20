import 'package:flutter/material.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      Padding(
        padding: const EdgeInsets.only(left: 25,right: 25,top: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.music_note,size: 40,),
                Text('Enjoy  your own  music',style: TextStyle(fontSize: 28,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
              ],
            ),
            SizedBox(height: 15,),
            Container(
              decoration: BoxDecoration(color: Colors.yellow,borderRadius: BorderRadius.circular(10)),
              width: double.infinity,
              height: 200,             
            ),
            SizedBox(height: 15,),
            Text('All Songs',style: TextStyle(fontStyle: FontStyle.italic,fontSize: 30,fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Divider(),
            
          ],
        ),
      )),
    );
  }
}