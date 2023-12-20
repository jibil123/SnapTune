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
    return Scaffold(
      body: Pages[currentindexvalue],
      bottomNavigationBar: BottomNavigationBar(
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
      )
    );
  }


}