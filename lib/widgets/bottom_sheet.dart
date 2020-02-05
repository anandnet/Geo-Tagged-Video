import 'dart:io';
import 'dart:typed_data';
import "package:flutter/material.dart";
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import "package:fluttertoast/fluttertoast.dart";
import '../utils/utils.dart' as utils;
import "../utils/global_variables.dart" as gv;
import './renameDialog.dart';
import './infoDialog.dart';
import './delete_dialog.dart';

class BottomEditSheet extends StatelessWidget {
  final String fileName;
  final String filePath;
  BottomEditSheet(this.fileName, this.filePath);
  final Color iconColor = Colors.black;
  //final Directory dir=Directory(filePath);
  @override
  Widget build(BuildContext context) {
    medinfo(filePath,fileName);
    return Container(
      height: 340,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, left: 17),
            height: 40,
            width: double.infinity,
            child: Text(
              fileName,
              textAlign: TextAlign.left,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.share,
              color: iconColor,
            ),
            title: Text("Share"),
            onTap: () {
              shareData();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.code,
              color: iconColor,
            ),
            title: Text("Extract KML"),
            onTap: () {
              getKML();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: iconColor,
            ),
            title: Text("Rename"),
            onTap: () {
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (context) => RenameDialog(filePath, fileName));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: iconColor,
            ),
            title: Text("Properties"),
            onTap: () {
              Navigator.of(context).pop();
              showDialog(context: context, builder: (context) => InfoDialog(filePath, fileName));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: iconColor,
            ),
            title: Text("Delete"),
            onTap: () {
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (context) => DeleteDialog(fileName, filePath));
            },
          ),
        ],
      ),
    );
  }

  shareData() async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    await audioFile.readAsBytes().then((value) {
      Uint8List bytes = Uint8List.fromList(value);
      shareFile(bytes);
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void shareFile(Uint8List bytes) async {
    await Share.file(fileName, fileName + ".mp4", bytes, "video/mp4");
  }

  void getKML() async {
    await utils
        .extract_metadata(
            filePath, gv.metaDataDirectory, fileName, "geo_location")
        .then((data) {
      utils.create_kml(data, gv.kmlDataDirectory + "/$fileName.KML");
      Fluttertoast.showToast(
          msg: 'Kml create to ${gv.kmlDataDirectory + "/$fileName.KML"}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    });
  }
}
Map<String,dynamic> mediaInfo={};
medinfo(String videoPath,String fileName)async{
  final _videoInfo = FlutterVideoInfo();
  _videoInfo.getVideoInfo(videoPath).then((info){
    mediaInfo={"filename":fileName,
                "duration":info.duration,
                "size":info.filesize,
                "height":info.height,
                "width":info.width,
              "path":videoPath
    };
  });
 }
