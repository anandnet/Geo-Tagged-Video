import 'dart:async';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart' show FlutterFFmpeg;
import 'package:file_utils/file_utils.dart';
import 'dart:io';


///Video encoding-decoding ............................

final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
void write_metadata(String path, String fileName, String tmpVidPath,String tmpVidName, String data){
    print("Called:: filepath: $path \n FileName: $fileName \n tmpVid: $tmpVidPath \n  data:$data ");
    // data should be single quoted string consisting of coordinates in below shown manner
    // comma separated-space separated
    // time1,lat1,long1,head1 time2,lat2,long2,head2 time3,lat3,long3,head3 etc.
    _flutterFFmpeg.execute("-i "+path+" -movflags use_metadata_tags -metadata geo_location=\'"+data+"\' -y -r 1 -acodec copy -vcodec copy "+tmpVidPath).then((rc){
      print("FFmpeg process exited with rc $rc");

      //delete old file
      delete(path);

      //rename new file to the old file
      rename(tmpVidPath, path);
      });

  }

Future<Map> extract_metadata(String videoPath, String tmpDir, String tagName) async {
  Map<String,List<String>> coordDict={};
  var blah = await _flutterFFmpeg.execute("-i "+videoPath+" -f ffmetadata "+tmpDir+"/tmp_meta.txt").then((rc) { 
  print("FFmpeg process exited with rc $rc");

  //extract information for tagName and delete tmp_meta.txt
  File file = new File(tmpDir+"/tmp_meta.txt");

  List<String> lines = file.readAsLinesSync();
  delete(tmpDir+"/tmp_meta.txt");

  lines.forEach((l){
    if(l.contains(tagName)){
      if(tagName=="geo_location"){
        String subStr= l.substring(l.indexOf("=")+1);
        List<String> coords= subStr.split(" ");
        
        coords.forEach((item){
          List<String> tmp = item.split(",");
          coordDict[tmp[0]]= tmp.sublist(1);
        });
      }
    }

    });
  });
  return coordDict;
  }

void rename(String oldPath, String newPath){
  //renames a file with 'newName' to 'oldName' in the path location
  FileUtils.rename(oldPath, newPath);
}

void delete(String fileName){
  //deletes a file named 'fileName' from path location
  FileUtils.rm([fileName]);
}


///kml data creater ........................

void create_kml(Map data, String path) {

  String kml_start = """
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
    <Document>
  """;
  String kml_end = """
    </Document>
  </kml>
  """;
  String inner_data="";

  data.forEach((key, val){
    inner_data+="""
  <Placemark>
        <name>$key</name>
        <description>Position at $key</description>
        <TimeStamp>$key</TimeStamp>
        <Point>
          <coordinates>${val[1]},${val[0]}</coordinates>
        </Point>
      </Placemark>
    """;
  });

  String kml_data= kml_start+inner_data+kml_end;

  _write(kml_data, path);

}void _write(String text, String path) async {
  final File file = File(path);
  await file.writeAsString(text);
}

//General utils..............................

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