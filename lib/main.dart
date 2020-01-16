import 'package:flutter/material.dart';
import './screen/video_recorder_screen.dart';
import './screen/video_player_screen.dart';
import './screen/home_screen.dart';
import './screen/video_list_screen.dart';
import 'package:camera/camera.dart';


List<CameraDescription> cameras;
void main(){
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //checkPermissions(context);
    checkCameras();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName:(context)=>HomeScreen(),
        VideoPlayerScreen.routeName:(context)=>VideoPlayerScreen(),
        VideoRecorderScreen.routeName:(context)=>VideoRecorderScreen(cameras),
        VideosListScreen.routeName:(context)=>VideosListScreen()
      },
    );
  }
}

Future<void> checkCameras() async{
cameras = await availableCameras();
} 
