import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snaptune/db/model.dart';
import 'package:snaptune/provider/provider.dart';
import 'package:snaptune/splashscreen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void>main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if(!Hive.isAdapterRegistered(MusicModelAdapter().typeId)) {
    Hive.registerAdapter(MusicModelAdapter());
  }
  if(!Hive.isAdapterRegistered(LikedSongModelAdapter().typeId)){
    Hive.registerAdapter(LikedSongModelAdapter());
  }
  runApp(
    ChangeNotifierProvider(create: (context)=>songModelProvider(),
    child: const MyApp(),)
  );
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
