import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "../providers/video_data.dart";
class DeleteDialog extends StatelessWidget {
  final String fileName;
  final String filePath;
  DeleteDialog(this.fileName,this.filePath);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete'),
      contentPadding: EdgeInsets.only(bottom: 0,right: 10,left: 22,top: 10),
      content: Container(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("The following file will be deleted permanently."),
            Text(fileName+".mp4",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
            Provider.of<VideoDataProvider>(context,listen: false).deleteVideo(filePath);
          },
        )
      ],
    );
  }
}