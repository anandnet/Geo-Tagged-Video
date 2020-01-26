import 'dart:async';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart' show FlutterFFmpeg;
import 'package:encrypt/encrypt.dart';
import 'package:file_utils/file_utils.dart';
import 'dart:io';


///Video encoding-decoding ............................

final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
void write_metadata(String path, String fileName, String tmpVidPath,String tmpVidName, String data, {bool encrypted=false}){
    // data should be single quoted string consisting of coordinates in below shown manner
    // comma separated-space separated
    // time1,lat1,long1,head1 time2,lat2,long2,head2 time3,lat3,long3,head3 etc.
    if(encrypted){
      data=intermediate_in(data);
    }
    _flutterFFmpeg.execute("-i "+path+" -movflags use_metadata_tags -metadata geo_location=\'"+data+"\' -y -r 1 -acodec copy -vcodec copy "+tmpVidPath).then((rc){
      print("FFmpeg process exited with rc $rc");

      //delete old file
      delete(path);

      //rename new file to the old file
      rename(tmpVidPath, path);
      });

  }

Future<Map> extract_metadata(String videoPath, String tmpDir,String fileName ,String tagName) async {
   bool isExist = FileSystemEntity.typeSync(tmpDir + "/$fileName.txt") !=FileSystemEntityType.notFound;
  Map<String,List<String>> coordDict={};
  if (isExist){
    return getTextToMap(tmpDir + "/$fileName.txt", tagName);
  }
  await _flutterFFmpeg.execute("-i "+videoPath+" -f ffmetadata "+tmpDir+"/$fileName.txt").then((rc) { 
  print("FFmpeg process exited with rc $rc");

    coordDict=getTextToMap(tmpDir + "/$fileName.txt", tagName);
  });
  return coordDict;
  }

  Map getTextToMap(String path,String tagName){
    Map<String,List<String>> coordDict={};
    //extract information for tagName and delete tmp_meta.txt
  final File file = new File(path);

  List<String> lines = file.readAsLinesSync();
  //file.delete();
  //delete(tmpDir+"/tmp_meta.txt");

  lines.forEach((l){
    if(l.contains(tagName)){
      if(tagName=="geo_location"){
        String subStr= l.substring(l.indexOf("=")+1);
        subStr= subStr.replaceAll(r"\", r"");
        try {
          subStr= intermediate_out(subStr);
        } catch (FormatException){ print("Location data not encoded");}
        List<String> coords= subStr.split(" ");
        coords.forEach((item){ 
          List<String> tmp = item.split(",");
          coordDict[tmp[0]]= tmp.sublist(1);
        });
      }
    }

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
    if(val.length!=0){
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
    }
  });

  String kml_data= kml_start+inner_data+kml_end;

  _write(kml_data, path);

}void _write(String text, String path) async {
  final File file = File(path);
  await file.writeAsString(text);
}

final ____ = Key.fromUtf8('dp/;|oip1*m#@1k57hd(d^d!d,s&.3q%');
final _iv = IV.fromLength(16);
final _encrypter = Encrypter(AES(____));

String intermediate_in(String data){
  final _encrypted = _encrypter.encrypt(data, iv: _iv);
  return _encrypted.base64;
}

String intermediate_out(data){
  //data= "wtxwPPqGqzY0ZsWXGHBdWqRM8L7WUyS8LIF+OF46YCXZzZzZdZAOgZtOYRyMhvQMWobUoe1DbGcG9D19tP6iwOvHkRwxTTqNlWqwnpNVP3cfvIlsok3NkTrqhSbezDUNhughrGLXABlcDFnCbQi+7maftBc57jvpK+2uNNtaZywdniE0UrN3K7YLy8v31T6UOuDtuz+0PdYWlolRiPLDnGJQH+ZNieMjQ1qlTtOo8IiSYfB4wLZBp2KS1dqE9iKheGMnXkM95+EuKPmvzizTiQUtofAO0bUPako95WyO87wwIZ7CsC7HyPHH5dWhzxsPCrhaxZ4LvcIAqFGW+WY1L+2uPZrhSWq83tP6+VftRj/u1tgzQzhusSCFErOvT80y5qtp7vfmR575+kmlgqM6ElPpQ23q2jtfCMv6RttLQLny3FTjowCZ4CVgibXokSIChCct3hl9n1uIvkKRfY/Pyd1hPzvYoYmCiXBjfDaoTIxv0ZLDjbRsdIggkADK8w5EB7T36gbq1tzJM+M9qAcyhMiTMov8kKmgfwUTOh+t02LsI4xpo3c6jE/fmEl6izu0VWwPasD2vObIO2saZoZFUEnASqDUquIEDDBGKRc3Y1+cFJSyMzCqDhqkCViI8eqlLIavhEGykxld16tMQxwcQC+iKdHdZine/eFLSFjx6xBj9YGX3pciE2s9FO3K0sQH6LFeEWv+evmbdQ3cJAeEj0ndzJZVucukLuBK8o+53DywSzskc0Iw/qxZDnb1rskaZvfZV9T6b3/QjBoOp/13ZF90MRxp0/JBFUnnpYwYXq/7ZgY2pZmeMd6bRN7BqAQeoOqMgexGdtjQjqx4ZKnGSdoYMcydzOEXuL9ma4gU4E1aYy5BgdLs1/3uLxcLdHcvyoLhtRBEJEAxst+lN4jEBzVh4/VOlag2fmZZxejMV6h+LEHK5WeEJmvDkinGayxdIgri/rLZl4Dpw4wL08RIlFvmRHP/a5pEKleJXGqee8varvJ0wAaAbDq5RDv17v9";
  final _decrypted = _encrypter.decrypt64(data, iv: _iv);
  return _decrypted.toString();
}