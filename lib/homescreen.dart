import 'package:flutter/material.dart';
import 'package:snaptune/sceens/library.dart';
import 'package:snaptune/sceens/main.home.dart';
import 'package:snaptune/sceens/search.dart';
import 'package:snaptune/sceens/settings.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List Pages=[
    MainHomeScreen(),
    SearchScreen(),
    LibraryScreen(),
    SettingScreen(),
  ];
  int currentindexvalue=0;

  @override
  Widget build(BuildContext context) {
    var _mediaquery=MediaQuery.of(context);
    return Scaffold(
      body: Pages[currentindexvalue],
      
      bottomNavigationBar: Stack(alignment: Alignment.bottomCenter,
        children: [
          InkWell(onTap: () {
            
          },
            child: Visibility(
              visible: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: Container(
                  width:_mediaquery.size.width*0.90,
                  height: _mediaquery.size.height *0.09,
                  decoration: BoxDecoration(color: Color.fromARGB(255, 101, 89, 89),borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    leading: Image(image: AssetImage('assets/images/Billie-Eilish-Happier-Than-Ever.webp')),
                    title: Text('Everything I Wanted'),
                    subtitle: Text('Bellie Eilish'),
                    trailing: Icon(Icons.pause,size: 50,),
                  )
                ),
              ),
            ),
          ),
          BottomNavigationBar(
            showUnselectedLabels: true,  
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            currentIndex: currentindexvalue,
            onTap: (value) => 
             setState(() {
               currentindexvalue=value;
             }),
            items: 
          [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home',backgroundColor: Colors.black),
            BottomNavigationBarItem(icon: Icon(Icons.search),label: 'Search',backgroundColor: Colors.black),
            BottomNavigationBarItem(icon: Icon(Icons.library_music),label: 'library',backgroundColor: Colors.black),
            BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Settings',backgroundColor: Colors.black),
          ],
          ),
        ],
      ),
    );
  }


}