import 'package:flutter/material.dart';
import './providers/video_data.dart';
import 'package:provider/provider.dart';
import './screens/video_recorder_screen.dart';
import './screens/video_player_screen.dart';
import './screens/home_screen.dart';
import './screens/video_list_screen.dart';
import './screens/splash_screen.dart';

void main(){
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //gv.onAppStart();
    return ChangeNotifierProvider(
      create: (context)=>VideoDataProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: SplashScreen(),
        routes: {
          HomeScreen.routeName:(context)=>HomeScreen(),
          VideoPlayerScreen.routeName:(context)=>VideoPlayerScreen(),
          VideoRecorderScreen.routeName:(context)=>VideoRecorderScreen(),
          VideosListScreen.routeName:(context)=>VideosListScreen()
        },
      ),
    );
  }
}