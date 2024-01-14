import 'package:flutter/material.dart';
import 'package:snaptune/screens/Library/library.dart';
import 'package:snaptune/screens/home/mainHome/main.home.dart';
import 'package:snaptune/screens/search/search.dart';
import 'package:snaptune/screens/settings/settings.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isContainerVisible = false;

  List Pages = [
    MainHomeScreen(),
    SearchScreen(),
    LibraryScreen(),
    SettingScreen(),
  ];
  int currentindexvalue = 0;

  @override
  Widget build(BuildContext context) {
    var _mediaquery = MediaQuery.of(context);
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
        // ],
      );
    // );
  }
}
