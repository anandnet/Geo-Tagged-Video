import 'package:flutter/material.dart';
import './screens/video_recorder_screen.dart';
import './screens/video_player_screen.dart';
import './screens/home_screen.dart';
import './screens/video_list_screen.dart';
import './utils/global_variables.dart' as gv;


void main(){
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    gv.onAppStart();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName:(context)=>HomeScreen(),
        VideoPlayerScreen.routeName:(context)=>VideoPlayerScreen(),
        VideoRecorderScreen.routeName:(context)=>VideoRecorderScreen(gv.cameras),
        VideosListScreen.routeName:(context)=>VideosListScreen()
      },
    );
  }
}