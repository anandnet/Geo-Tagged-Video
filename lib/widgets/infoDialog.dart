import 'package:flutter/material.dart';
import '../widgets/bottom_sheet.dart';
import '../utils/global_variables.dart' as gv;

class InfoDialog extends StatelessWidget {
  final String filePath;
  final String fileName;
  InfoDialog(this.filePath, this.fileName);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Properties'),
      content: Text(
          "Name: ${mediaInfo["filename"]}\nSize: ${(mediaInfo["size"] / (1024 * 1024)).toStringAsFixed(1)
          } MB\nduration: ${gv.transformMilliSeconds((mediaInfo["duration"]).toInt())}\nResolution: ${mediaInfo["width"]
          }*${mediaInfo["height"]}\nPath: ${mediaInfo["path"]
          }"),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}