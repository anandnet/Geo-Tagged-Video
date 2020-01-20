import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './video_player_screen.dart';
import "../utils/utils.dart" as utils;

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
                itemCount: filePath.length,
                itemBuilder: ((context, index) {
                  return Column(
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
    final Directory appDirectory = await getExternalStorageDirectory();
    final String tmpDirectory = '${appDirectory.path}/tmp';
    await Directory(tmpDirectory).create(recursive: true);
    Map<String,List<String>> x=await utils.extract_metadata(videoPath,tmpDirectory,tagName);
    //print("im x.... "+x.toString());
    Map<String,List<double>> data={};
    x.forEach((key,val){data[key]=val.map(double.parse).toList();});
    print(x);
    print(data);
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
