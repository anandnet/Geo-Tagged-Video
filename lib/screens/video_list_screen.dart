import 'dart:io';
import 'package:geo_tagged_video/providers/video_data.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import './video_player_screen.dart';
import "../utils/utils.dart" as utils;
import "../utils/global_variables.dart" as gv;
import "../widgets/bottom_sheet.dart";
import '../widgets/data_search.dart';

class VideosListScreen extends StatefulWidget {
  static const routeName = "/video-list-screen";
  @override
  _VideosListScreenState createState() => _VideosListScreenState();
}

class _VideosListScreenState extends State<VideosListScreen> {
  @override
  void initState() {
    Provider.of<VideoDataProvider>(context, listen: false).fetchvideoList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> videosList =
        Provider.of<VideoDataProvider>(context).videoList;
    final List<String> videosName =
        videosList.map((each) => path.basename(each).split(".")[0]).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Video List"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: DataSearch(),
                  );
            },
          ),
        ],
      ),
      body: Container(
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
                  //final videoName = path.basename(File(videosList[index]).path);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.only(right: 0, left: 15),
                        title: Text(videosName[index]),
                        onTap: () {
                          getMapdata(videosList[index], "geo_location",
                              videosName[index], context);
                        },
                        onLongPress: () {
                          openBottomSheet(
                              context, videosName[index], videosList[index]);
                        },
                        leading: Container(
                          height: 140,
                          width: 100,
                          child: checkCache(videosName[index])
                              ? Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  margin: EdgeInsets.all(0),
                                  elevation: 7,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.file(
                                      File(gv.temporaryDirectory +
                                          "/${videosName[index]}.jpg"),
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
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7)),
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
                          onPressed: () {
                            openBottomSheet(
                                context, videosName[index], videosList[index]);
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
      ),
    );
  }


  Future<String> getThumbnail(String videoPath) async {
    String thumbPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: gv.temporaryDirectory,
        imageFormat: ImageFormat.JPEG,
        maxHeight:
            100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 100);
    return thumbPath;
  }

  openBottomSheet(BuildContext ctx, String fileName, String filePath) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return BottomEditSheet(fileName, filePath);
      },
    );
  }

  checkCache(String fileName) {
    bool isExist =
        FileSystemEntity.typeSync(gv.temporaryDirectory + "/$fileName.jpg") !=
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


getMapdata(String videoPath, String tagName, String fileName,
      BuildContext context) async {
    Map<String, List<String>> x = await utils.extract_metadata(
        videoPath, gv.metaDataDirectory, fileName, tagName);
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