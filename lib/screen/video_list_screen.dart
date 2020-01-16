import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import './video_player_screen.dart';

class VideosListScreen extends StatefulWidget {
  static const routeName = "/video-list-screen";
  @override
  _VideosListScreenState createState() => _VideosListScreenState();
}

class _VideosListScreenState extends State<VideosListScreen> {
  @override
  Widget build(BuildContext context) {
    final filePath = ModalRoute.of(context).settings.arguments as List;
    return Scaffold(
      appBar: AppBar(
        title: Text("Video List"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        child: (filePath.length == 0)
            ? Container(
                child: Center(child: Text(
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
                          Navigator.of(context).pushNamed(
                              VideoPlayerScreen.routeName,
                              arguments: filePath[index]);
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
}
