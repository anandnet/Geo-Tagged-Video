import 'package:flutter/foundation.dart';
import 'dart:io';
import '../utils/global_variables.dart' as gv;

class VideoDataProvider with ChangeNotifier {
  List<String> _vidList = [];

  void fetchvideoList() {
    _vidList=[];
    try {
      List<FileSystemEntity> list = Directory(gv.videoDirectory).listSync();
      list.forEach((file) {
        _vidList.add(file.path);
      });
    } catch (e) {
    }
  }

  get videoList{
    return _vidList;
  }

  deleteVideo(String filePath) async {
    await File(filePath).delete().then((status){
      videoList.remove(filePath);
      print(videoList);
      notifyListeners();
    });
  }

  renameVideo(String filePath,String newPath) async {
    await File(filePath).rename(newPath).then((status){
          final int index=videoList.indexWhere((path)=>path==filePath);
          videoList.removeAt(index);
          videoList.insert(index,newPath);
          print(status);
          notifyListeners();
        });
  }
}
