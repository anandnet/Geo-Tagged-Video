import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import "package:fluttertoast/fluttertoast.dart";
import 'package:geolocator/geolocator.dart';
import '../utils/utils.dart' as utils;
import "../utils/global_variables.dart" as gv;
import "package:location/location.dart" as loc;

class VideoRecorderScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  VideoRecorderScreen(this.cameras);
  static const routeName = "/video-recorder-screen";

  @override
  State<StatefulWidget> createState() {
    return _VideoRecorderScreenState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _VideoRecorderScreenState extends State<VideoRecorderScreen> {
  CameraController controller;
  Stopwatch watch = new Stopwatch();
  Timer timer;

  var geolocator = Geolocator();
  var location=loc.Location();
  Position currentLocation;
  String elapsedTime = '';

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      location.requestService();
      updateLocation();
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  updateLocation() async {
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 0);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      currentLocation = position;
    });
  }

  @override
  void dispose() {
    print("dispose");
    if (controller != null) {
      controller.dispose();
    }
    super.dispose();
  }

  var recording = false;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    //print("build");
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Recorder"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: mq.size.height * .7,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: (!controller.value.isInitialized)
                  ? new Container()
                  : CameraPreview(controller),
            ),
          ),
          Container(
            height: mq.size.height * .19,
            child: Row(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    width: mq.size.width * .4,
                    child: Text(elapsedTime)),
                Container(
                  width: mq.size.width * .2,
                  alignment: Alignment.center,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (recording) {

                            _onStopButtonPressed();
                            stopWatch();
                            reSetWatch();
                            elapsedTime = "00:00";
                          } else {
                            _onRecordButtonPressed();
                            startWatch();
                          }
                          recording = !recording;
                        });
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                        child: recording
                            ? Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(color: Colors.white))
                            : CircleAvatar(
                                radius: 10,
                              ),
                      )),
                ),
                Container(
                  width: mq.size.width * .4,
                  child: GestureDetector(
                    child: CircleAvatar(
                      child: IconButton(
                        icon: Icon(
                          Icons.switch_camera,
                        ),
                        onPressed: () {
                          _onSwitchCamera();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }

///Camera Part......
  int selectedCameraIdx;
  String videoPath;
  String mapDataFilePath;

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        Fluttertoast.showToast(
            msg: 'Camera error ${controller.value.errorDescription}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() {
    if (selectedCameraIdx == 1) {
      selectedCameraIdx = 0;
    } else {
      selectedCameraIdx = 1;
    }
    CameraDescription selectedCamera = widget.cameras[selectedCameraIdx];
    _onCameraSwitched(selectedCamera);
    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  void _onRecordButtonPressed() {
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {
        Fluttertoast.showToast(
            msg: 'Recording video started',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      }
    });
  }
String filename="";
String tmpVideoPath="";
  void _onStopButtonPressed() {
    _stopVideoRecording().then((_) {
      utils.write_metadata(videoPath, filename, tmpVideoPath,"tmp_"+filename, videoLog);
      if (mounted) setState(() {});
      Fluttertoast.showToast(
          msg: 'Video saved to $videoPath',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    });
  }

  
  Future<String> _startVideoRecording() async {
    if (!controller.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Please wait',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);

      return null;
    }

    // Do nothing if a recording is on progress
    if (controller.value.isRecordingVideo) {
      return null;
    }

    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String mapDFilePath = "${gv.mapDataDirectory}/$currentTime.json";
    final String filePath = '${gv.videoDirectory}/$currentTime.mp4';

    try {
      await controller.startVideoRecording(filePath);
      tmpVideoPath=  '${gv.videoDirectory}/tmp_$currentTime.mp4';
      videoPath = filePath;
      mapDataFilePath = mapDFilePath;
      filename="$currentTime.mp4";
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  Future<void> _stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    Fluttertoast.showToast(
        msg: 'Error: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  Map<String, List> _mapData = {};
  String videoLog='';

  void saveJSONFile() {
    File file = new File(mapDataFilePath);
    file.createSync();
    file.writeAsStringSync(json.encode(_mapData));
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      if (mounted) {
        setState(() {
          elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
          if(currentLocation!=null){
          videoLog+="$elapsedTime,${currentLocation.latitude},${currentLocation.longitude},${currentLocation.heading} ";
          
          _mapData[elapsedTime] = [
            currentLocation.latitude,
            currentLocation.longitude,
            currentLocation.altitude,
            currentLocation.heading
          ];
          }
          Fluttertoast.showToast(
              msg:
                  'Heading: ${currentLocation.heading},Logitute: ${currentLocation.longitude},',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white);
        });
      }
    }
  }

  startWatch() {
    watch.start();
    timer = new Timer.periodic(new Duration(milliseconds: 1000), updateTime);
  }

  stopWatch() {
    watch.stop();
    timer.cancel();
    setTime();
    print(_mapData);
    saveJSONFile();
    print(videoLog);
    _mapData.clear();
  }

  reSetWatch() {
    watch.reset();
    setTime();
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }
}
