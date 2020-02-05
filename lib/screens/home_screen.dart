import 'package:flutter/material.dart';
import '../screens/video_list_screen.dart';
import '../screens/video_recorder_screen.dart';
import "../utils/global_variables.dart" as gv;

class HomeScreen extends StatelessWidget {
  static const routeName = "/home-screen";

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    gv.onAppStart();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 20),
                height: mq.size.height * .095,
                child: Text(
                  "GeoCam",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    // height: mq.size.height*.796,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(60),
                            bottomRight: Radius.circular(20),
                            topRight: Radius.circular(0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        screenSelectorBtn(context, Icons.videocam),
                        screenSelectorBtn(context, Icons.music_video),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

//Screen Selecter Button
  Widget screenSelectorBtn(BuildContext context, IconData icon) {
    final MediaQueryData mq = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        if (icon == Icons.videocam) {
          Navigator.of(context).pushNamed(VideoRecorderScreen.routeName);
        } else {
          Navigator.of(context).pushNamed(VideosListScreen.routeName);
        }
      },
      child: Center(
        child: Container(
          height: mq.size.height * .3,
          width: mq.size.width * .8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                icon,
                size: 150,
                color: Colors.white,
              ),
              Text(
                icon == Icons.videocam ? "Video Recorder" : "Video Player",
                style: TextStyle(fontSize: 30, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
