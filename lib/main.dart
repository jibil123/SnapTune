import 'package:flutter/material.dart';
import 'package:snaptune/splashscreen.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark
      ),
      debugShowCheckedModeBanner: false,
      title: 'weepk_8.Project',
      home:SplashScreen(),
    );
  }
}
