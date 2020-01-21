import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import './video_player_screen.dart';
import "../utils/utils.dart" as utils;
import "../utils/global_variables.dart" as gv;

class VideosListScreen extends StatefulWidget {
  static const routeName = "/video-list-screen";
  @override
  _VideosListScreenState createState() => _VideosListScreenState();
}

class _VideosListScreenState extends State<VideosListScreen> {
  @override
  Widget build(BuildContext context) {
    final filePath = ModalRoute.of(context).settings.arguments as List<String>;
    return Scaffold(
      appBar: AppBar(
        title: Text("Video List"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        child: (filePath.length == 0)
            ? Container(
                child: Center(
                    child: Text(
                  "No Files",
                  style: TextStyle(fontSize: 25),
                )),
              )
            : ListView.builder(
             // itemExtent:80,
                itemCount: filePath.length,
                itemBuilder: ((context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Divider(),
                      InkWell(
                        splashColor: Colors.blue,
                        onTap: () {
                          getMapdata(File(filePath[index]).path, "geo_location",filePath[index],context);
                        },
                        child: ListTile(
                          title: Text(basename(File(filePath[index]).path)),
                          leading: Container(
                            height: 140,
                            width: 100,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
      ),
    );
  }
  getMapdata(String videoPath,String tagName,String args,BuildContext context)async {
    Map<String,List<String>> x=await utils.extract_metadata(videoPath,gv.tmpDirectory,tagName);
    Map<String,List<double>> data={};
    x.forEach((key,val){data[key]=val.map(double.parse).toList();});
    final List<double> source=data.entries.elementAt(0).value;
    final List<double> destination=data.entries.elementAt(data.length-2).value;
    Todos todo=Todos(path: args,mapData:data ,source:source,destination: destination );
   Navigator.of(context).pushNamed( VideoPlayerScreen.routeName,arguments: todo);
  }
}

class Todos{
  final String path;
  final Map<String,List<double>> mapData;
  final List<double> source;
  final List<double> destination;
  Todos({this.path,this.mapData,this.source,this.destination});
}
