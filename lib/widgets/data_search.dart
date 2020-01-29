import 'package:flutter/material.dart';
import 'package:geo_tagged_video/providers/video_data.dart';
import "package:path/path.dart" as path;
import 'package:provider/provider.dart';
import '../screens/video_list_screen.dart' as vidListScr;
import 'bottom_sheet.dart';

class DataSearch extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> videosPath =
        Provider.of<VideoDataProvider>(context).videoList;
    final List<String> videosName =
        videosPath.map((each) => path.basename(each).split(".")[0]).toList();
    final suggestionList = query.isEmpty
        ? []
        : videosName.where((qd) => qd.startsWith(query)).toList();
    return ListView.builder(
      itemExtent: 55,
      itemBuilder: (context, index) {
        final String videoName =
            path.basename(suggestionList[index]).split(".")[0];
        final int index1 = videosName.indexOf(videoName);
        return ListTile(
          contentPadding: EdgeInsets.only(right: 0, left: 15),
          leading: Icon(
            Icons.music_video,
            color: Colors.black,
            size: 27,
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return BottomEditSheet(videoName, videosPath[index1]);
                },
              );
            },
          ),
          title: RichText(
              text: TextSpan(
            text: videoName.substring(0, query.length),
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: videoName.substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ],
          )),
          onTap: () {
            vidListScr.getMapdata(
                videosPath[index1], "geo_location", videoName, context);
          },
        );
      },
      itemCount: suggestionList.length,
    );
  }
}
