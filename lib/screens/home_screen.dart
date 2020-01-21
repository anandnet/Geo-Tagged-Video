import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/video_list_screen.dart';
import '../screens/video_recorder_screen.dart';
import "../utils/global_variables.dart" as gv;
class HomeScreen extends StatelessWidget {
  static const routeName="/home-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geo Tagged Video"),
      ),
      body:Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            screenSelectorBtn(context, Icons.videocam),
            screenSelectorBtn(context, Icons.music_video),
          ],
        )
      )
    );
  }

//Screen Selecter Button
Widget screenSelectorBtn(BuildContext context,IconData icon){
    final MediaQueryData mq=MediaQuery.of(context);
    return GestureDetector(
      onTap: (){
        if(icon==Icons.videocam){
           Navigator.of(context).pushNamed(VideoRecorderScreen.routeName);
        }
        else{
          getFileList(context);
        }    
            },
      child: Center(
        child: Container(
          height: mq.size.height*.35,
          width: mq.size.width*.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).primaryColor,
            ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(icon,
                size: 200,
                color: Colors.white,
              ),
              Text(icon==Icons.videocam ? "Video Recorder":"Video Player",
                style: TextStyle(
                  fontSize:30,
                  color: Colors.white
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

///Get file list from videos directory
  getFileList(BuildContext context) async{
  try{
  Directory dir = Directory(gv.videoDirectory);
  List<String> videosPath=[];
    dir.list(recursive: false).forEach((f) {
      videosPath.add(f.path);
    });
  Navigator.of(context).pushNamed(VideosListScreen.routeName,arguments: videosPath);
  } on Exception catch (e) {
      print(e);
      return null;
    }
}



}