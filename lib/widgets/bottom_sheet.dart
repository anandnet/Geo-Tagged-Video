import 'dart:typed_data';
import "package:flutter/material.dart";
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/services.dart';
import "package:fluttertoast/fluttertoast.dart";
import '../utils/utils.dart' as utils;
import "../utils/global_variables.dart" as gv;
import './renameDialog.dart';
import './infoDialog.dart';
import './delete_dialog.dart';
class BottomEditSheet extends StatelessWidget {
  final String fileName;
  final String filePath;
  BottomEditSheet(this.fileName,this.filePath);
  final Color iconColor=Colors.black;
  //final Directory dir=Directory(filePath);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      child: Column(
        children:[
          Container(
            padding: const EdgeInsets.only(top: 10,left: 17),
          height: 40,
          width: double.infinity,
          child: Text(fileName,textAlign: TextAlign.left,),
          ),
          ListTile(
            leading: Icon(Icons.share,color: iconColor,),
            title: Text("Share"),
            onTap: (){shareData();},
          ),
          ListTile(
            leading: Icon(Icons.code,color: iconColor,),
            title: Text("Extract KML"),
            onTap: (){
              getKML();
            },
          ),
          ListTile(
            leading: Icon(Icons.edit,color: iconColor,),
            title: Text("Rename"),
            onTap: (){
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context)=>RenameDialog(filePath,fileName)
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info,color: iconColor,),
            title: Text("Properties"),
            onTap: (){
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context)=>InfoDialog()
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.delete,color: iconColor,),
            title: Text("Delete"),
            onTap: (){
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context)=>DeleteDialog(fileName,filePath)
              );
            },
          ),
        ],     
      ),
    );
  }
  shareData()async{
    final ByteData bytes = await rootBundle.load(filePath);
    await Share.file(fileName, fileName+".mp4", bytes.buffer.asUint8List(), "video/mp4");
  } 

  void getKML()async{
  await utils.extract_metadata(filePath, gv.metaDataDirectory, fileName, "geo_location").then((data){
    //print(data);
    utils.create_kml(data,gv.kmlDataDirectory+"/$fileName.KML");
    Fluttertoast.showToast(
            msg: 'Kml create to ${gv.kmlDataDirectory+"/$fileName.KML"}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white);
  });
    
     
  }

}