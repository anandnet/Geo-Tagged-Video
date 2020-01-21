import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

startWatch(timer,watch,updateTime) {
    watch.start();
    timer = new Timer.periodic(new Duration(milliseconds: 900), updateTime);
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }


Directory appDirectory ;
String videoDirectory ;
String mapDataDirectory ;
String tmpDirectory;
List<CameraDescription> cameras;

onAppStart()async{
appDirectory = await getExternalStorageDirectory();
videoDirectory = '${appDirectory.path}/Videos';
mapDataDirectory = '${appDirectory.path}/mapDataDirectory';
tmpDirectory = '${appDirectory.path}/tmp';
cameras = await availableCameras();
await Directory(videoDirectory).create(recursive: true);
await Directory(mapDataDirectory).create(recursive: true);
await Directory(tmpDirectory).create(recursive: true);
}
