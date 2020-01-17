
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart' show FlutterFFmpeg;
import 'package:file_utils/file_utils.dart';
import 'dart:io';

final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

void write_metadata(String path, String fileName, String tmpVid, String data){
    // data should be single quoted string consisting of coordinates in below shown manner
    // comma separated-space separated
    // time1,lat1,long1,head1 time2,lat2,long2,head2 time3,lat3,long3,head3 etc.
    _flutterFFmpeg.execute("-i "+path+"/"+fileName+" -movflags use_metadata_tags -metadata geo_location="+data+" -y -r 1 -acodec copy -vcodec copy "+path+"/"+tmpVid).then((rc){
      print("FFmpeg process exited with rc $rc");

      //delete old file
      delete(path, fileName);

      //rename new file to the old file
      rename(path, tmpVid, fileName);
      });

  }

Future<Map> extract_metadata(String path, String fileName, String tagName) async {
  
  var coordDict={};
  var blah = await _flutterFFmpeg.execute("-i "+path+"/"+fileName+" -f ffmetadata "+path+"/tmp_meta.txt").then((rc) { 
  print("FFmpeg process exited with rc $rc");

  //extract information for tagName and delete tmp_meta.txt
  File file = new File(path+"/tmp_meta.txt");

  List<String> lines = file.readAsLinesSync();
  delete(path, "tmp_meta.txt");

  lines.forEach((l){
    if(l.contains(tagName)){
      if(tagName=="geo_location"){
        String subStr= l.substring(l.indexOf("=")+1);
        var coords= subStr.split(" ");
        
        coords.forEach((item){
          var tmp = item.split(",");
          coordDict[tmp[0]]= tmp.sublist(1);
        });
      }
    }

    });
  });
  return coordDict;
  }

void rename(String path, String oldName, String newName){
  //renames a file with 'newName' to 'oldName' in the path location
  FileUtils.rename(path+"/"+oldName, path+"/"+newName);
}

void delete(String path, String fileName){
  //deletes a file named 'fileName' from path location
  FileUtils.rm([path+"/"+fileName]);
}
