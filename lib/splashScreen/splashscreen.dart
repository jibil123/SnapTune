import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snaptune/bottomNavScreen/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Permission.storage.request();
    Timer(const Duration(seconds: 3), () { 
      Navigator.pushReplacement (context, MaterialPageRoute(builder: (context)=>HomeScreen()),);
    });
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image(image: AssetImage('assets/images/splashscreen.png')),
      ),
    );
  }
}