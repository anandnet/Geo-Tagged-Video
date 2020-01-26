import 'dart:io';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../providers/video_data.dart';
class RenameDialog extends StatefulWidget {
  final String filePath;
  final String fileName;
  RenameDialog(this.filePath,this.fileName);

  @override
  _RenameDialogState createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
 final  TextEditingController _textFieldController = TextEditingController();

 final String errorMessage1="filename not provided!";
 final String errorMessage2="filename alreay exists!";

 int a=0;

 @override
  void initState() {
    _textFieldController.text=widget.fileName;
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rename to'),
      content: TextField(
        autofocus: true,
        controller: _textFieldController,
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          hintText: "New Name",
          errorText: (a==1)?errorMessage1:(a==2)? errorMessage2: null,
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
            if(_textFieldController.text!="")
            {
              print(_textFieldController.text);
              final nameSplit=widget.filePath.split("/");
              final newPath=widget.filePath.replaceFirst(nameSplit[nameSplit.length-1], "${_textFieldController.text}.mp4");
              final isExist = FileSystemEntity.typeSync(newPath)!=FileSystemEntityType.notFound;
              if(!isExist)
              {  
                Navigator.of(context).pop();
                Provider.of<VideoDataProvider>(context,listen: false).renameVideo(widget.filePath, newPath);
                }
              else{
                setState(() {
                  a=2;
                });
              }
            }
            else{
              setState(() {
                a=1;
              });
            }
          },
        )
      ],
    );
  }
}
