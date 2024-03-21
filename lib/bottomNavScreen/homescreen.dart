import 'package:flutter/material.dart';
import 'package:snaptune/screens/Library/library.dart';
import 'package:snaptune/screens/home/mainHome/main.home.dart';
import 'package:snaptune/screens/search/search.dart';
import 'package:snaptune/screens/settings/settings.dart';

class HomeScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isContainerVisible = false;

  // ignore: non_constant_identifier_names
  List  Pages = [
    const MainHomeScreen(),
    SearchScreen(),
    const LibraryScreen(),
    const SettingScreen(),
  ];
  int currentindexvalue = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pages[currentindexvalue],
      bottomNavigationBar:
          BottomNavigationBar(
            showUnselectedLabels: true,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            currentIndex: currentindexvalue,
            onTap: (value) => setState(() {
              currentindexvalue = value;
            }),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Colors.black),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                  backgroundColor: Colors.black),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_music),
                  label: 'library',
                  backgroundColor: Colors.black),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                  backgroundColor: Colors.black),
            ],
          ),
      );
  }
}
