import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Video List"),
        ),
        body: getList(context));
  }

  Widget getList(BuildContext context) {
    final videosList =
        ModalRoute.of(context).settings.arguments as List<String>;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: (videosList.length == 0)
          ? Container(
              child: Center(
                  child: Text(
                "No Files",
                style: TextStyle(fontSize: 25),
              )),
            )
          : ListView.builder(
              itemExtent: 80,
              itemCount: videosList.length,
              itemBuilder: ((context, index) {
                final videoName = basename(File(videosList[index]).path);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Divider(),
                    InkWell(
                      splashColor: Colors.redAccent,
                      onTap: () {
                        getMapdata(videosList[index], "geo_location", context);
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.only(right: 0, left: 15),
                        title: Text(videoName.split(".")[0]),
                        leading: Container(
                          height: 140,
                          width: 100,
                          child: checkCache(videoName)
                              ? Card(
                                  margin: EdgeInsets.all(0),
                                  elevation: 7,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.file(
                                      File(gv.temporaryDirectory +
                                          "/${videoName.split(".")[0]}.jpg"),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                )
                              : FutureBuilder(
                                  future: getThumbnail(videosList[index]),
                                  builder: (context, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    }
                                    return Card(
                                      margin: EdgeInsets.all(0),
                                      elevation: 7,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.file(
                                          File(snap.data),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
    );
  }

  getMapdata(String videoPath, String tagName, BuildContext context) async {
    Map<String, List<String>> x =
        await utils.extract_metadata(videoPath, gv.tmpDirectory, tagName);
    Map<String, List<double>> data = {};
    x.forEach((key, val) {
      data[key] = val.map(double.parse).toList();
    });
    final List<double> source = data.entries.elementAt(0).value;
    final List<double> destination =
        data.entries.elementAt(data.length - 2).value;
    Todos todo = Todos(
        path: videoPath,
        mapData: data,
        source: source,
        destination: destination);
    Navigator.of(context)
        .pushNamed(VideoPlayerScreen.routeName, arguments: todo);
  }

  Future<String> getThumbnail(String videoPath) async {
    String thumbPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: gv.temporaryDirectory,
        imageFormat: ImageFormat.JPEG,
        maxHeight:
            100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 100);
    print(thumbPath);
    return thumbPath;
  }

  checkCache(String fileName) {
    bool isExist = FileSystemEntity.typeSync(
            gv.temporaryDirectory + "/${fileName.split(".")[0]}.jpg") !=
        FileSystemEntityType.notFound;
    return isExist;
  }
}

class Todos {
  final String path;
  final Map<String, List<double>> mapData;
  final List<double> source;
  final List<double> destination;
  Todos({this.path, this.mapData, this.source, this.destination});
}
