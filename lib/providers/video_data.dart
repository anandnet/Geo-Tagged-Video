import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';

class VideoData{
  String name;
  String datetime;
  String duration;
  String path;
  VideoData({this.name,this.datetime,this.duration,this.path});
}

class VideoProvider extends ChangeNotifier{
  List<VideoData> _videos=[];

  Future<List<FileSystemEntity>> dirContents(Directory dir) {
  var files = <FileSystemEntity>[];
  var completer = new Completer();
  var lister = dir.list(recursive: false);
  lister.listen ( 
      (file) => files.add(file),
      // should also register onError
      onDone:   () => completer.complete(files)
      );
    print(files);
    
  return completer.future;
}

}

void main(List<String> args) {
  var myDir = new Directory('../screen');
  VideoProvider().dirContents(myDir);
}