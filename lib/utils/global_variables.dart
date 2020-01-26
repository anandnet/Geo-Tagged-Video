import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import "package:permission_handler/permission_handler.dart" as str;

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
String temporaryDirectory;
String metaDataDirectory;
String kmlDataDirectory;

onAppStart()async{
  await str.PermissionHandler().requestPermissions([str.PermissionGroup.storage]).then((per){
    if(per[str.PermissionGroup.storage]==str.PermissionStatus.granted){
        appDirectory = Directory('/storage/emulated/0/Geocam');
        if (!appDirectory.existsSync()) 
          appDirectory.create();
        createDir("granted");
    }
    else{
      createDir("discard");
    }
  });

cameras = await availableCameras();
temporaryDirectory=(await getTemporaryDirectory()).path;
metaDataDirectory="$temporaryDirectory/metadata";
await Directory(metaDataDirectory).create(recursive: true);
}

createDir(String status)async{
  if(status=="discard"){
    appDirectory = await getExternalStorageDirectory();
  }
  videoDirectory = '${appDirectory.path}/Videos';
  kmlDataDirectory="${appDirectory.path}/KML Data";
  await Directory(videoDirectory).create(recursive: true);
  await Directory(kmlDataDirectory).create(recursive: true);
}