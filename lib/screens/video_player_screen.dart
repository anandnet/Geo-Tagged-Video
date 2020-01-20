import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:flutter_polyline_points/flutter_polyline_points.dart";
import "../utils/utils.dart" as utils;
import "../screens/video_list_screen.dart";


class VideoPlayerScreen extends StatefulWidget {
  static const routeName = "/video-player-screen";
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    print("init_state called");
    super.initState();
    //utils.startWatch(timer,watch,updateTime);
    setSourceAndDestinationIcons();
  }


  @override
  void didChangeDependencies() {
    print("did change dipendecy called");
    final a = ModalRoute.of(context).settings.arguments as Todos;
    var myFile = new File(a.path);
    data=a.mapData;
    source=a.source;
    destination=a.destination;
    _videoPlayerController = VideoPlayerController.file(myFile);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 4,
      autoPlay: true,
      looping: false,
      // Try playing around with some of these other options:
      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      placeholder: Container(
        color: Colors.grey,
      ),
      // autoInitialize: true,
    );
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }


  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    watch.stop();
    if(timer!=null)
      timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target:LatLng(source[0], source[1]));
    if (data[videoPosition] != null && videoPosition!="") {
      initialCameraPosition = CameraPosition(
          target: LatLng(data[videoPosition][0], data[videoPosition][1]), //change
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: mq.size.height * .4,
            child: Chewie(
              controller: _chewieController,
            ),
          ),
          Expanded(
            child: GoogleMap(
               myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
           markers: _markers,
            polylines: _polylines,
           mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: onMapCreated
            ),
          )
        ],
      ),
    );
  }

///Related to timer.........................
String elapsedTime = "";
Stopwatch watch = new Stopwatch();
Timer timer;
String videoPosition="";

updateTime(Timer timer) {
  if (watch.isRunning) {
    if (mounted) {
      setState(() {
        //elapsedTime = utils.transformMilliSeconds(watch.elapsedMilliseconds);
        var milliSeconds=_chewieController.videoPlayerController.value.position.inMilliseconds;
        //videoPosition=utils.transformMilliSeconds(milliSeconds);
        print(videoPosition);
        updatePinOnMap();
      });
      
    }
  }
}

  
 
//Related to maps.........................................
List<double> source=[];
List<double> destination=[];
final double CAMERA_ZOOM = 15;
final double CAMERA_TILT = 3;
final double CAMERA_BEARING = 30;

void onMapCreated(GoogleMapController controller) {
     _controller.complete(controller);
     setMapPins();
      //setPolylines();
  }

 Completer<GoogleMapController> _controller = Completer();
    Set<Marker> _markers = {};
    Set<Polyline> _polylines = {};
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    String googleAPIKey = "AIzaSyBghv3791cknOTIcjSnmoAqokcs3JiN2L8";
     BitmapDescriptor sourceIcon;
    BitmapDescriptor destinationIcon;
    BitmapDescriptor locationIcon;
   

Map<PolylineId, Polyline> polylines = {};
 
void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position:LatLng(source[0], source[1]),
          icon: sourceIcon));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: LatLng(destination[0], destination[1]),
          icon: destinationIcon));
      _markers.add(Marker(
          markerId: MarkerId('directionPin'),
          position: LatLng(source[0], source[1]),
          icon: locationIcon));
    });
  }

void setSourceAndDestinationIcons() async {
      sourceIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png');
      destinationIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5),
          'assets/destination.png');
      sourceIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png');
      locationIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5),
          'assets/pointer1.png');
    }

/*
void setPolylines() async {
  List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      22.9592961, 88.4238374,
     22.9613034, 88.4336292//souce
      );//destination
  if (result.isNotEmpty) {
    result.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
    setState(() {
      _polylines.add(Polyline(
          width: 5, // set the width of the polylines
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates));
    });
  }
}*/

void updatePinOnMap() async {
  if(data[videoPosition]!=null){
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(data[videoPosition][0], data[videoPosition][1]), //chanfr
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
      var pinPosition = LatLng(data[videoPosition][0], data[videoPosition][1]); //change
      _markers.removeWhere((m) => m.markerId.toString() == 'sourcePin');
      _markers.removeWhere((m) => m.markerId.toString() == 'directionPin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: sourceIcon,
          ));
      _markers.add(Marker(
          markerId: MarkerId('directionPin'),
          position: pinPosition, // updated position
          icon: locationIcon,
          rotation: data[videoPosition]!=null ? data[videoPosition][2] :0
          ));
    }
    else{
      Fluttertoast.showToast(
              msg:'No Location data at $videoPosition',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white);
    }
}
Map<String, List<double>> data ={};

/*
Map<String, List<double>> data = {
    "00:00": [22.9592961, 88.4238374, -30.233673095703125, 0.0],
    "00:01": [22.9592961, 88.4238374, -30.233673095703125, 0.0],
    "00:02": [22.9592961, 88.4238374, -30.233673095703125, 0.0],
    "00:03": [22.9593069, 88.4238481, -19.470703125, 152.89564514160156],
    "00:04": [22.9593069, 88.4238481, -19.470703125, 152.89564514160156],
    "00:05": [22.9593069, 88.4238481, -19.470703125, 152.89564514160156],
    "00:06": [22.9593069, 88.4238481, -19.470703125, 152.89564514160156],
    "00:07": [22.9593069, 88.4238481, -19.470703125, 152.89564514160156],
    "00:08": [22.9593067, 88.4238475, -19.445465087890625, 247.3876495361328],
    "00:09": [22.9593067, 88.4238475, -19.445465087890625, 247.3876495361328],
    "00:10": [22.9593067, 88.4238475, -19.445465087890625, 247.3876495361328],
    "00:11": [22.9593077, 88.4238494, 35.1, 54.089298248291016],
    "00:12": [22.9593077, 88.4238494, 35.1, 54.089298248291016],
    "00:13": [22.9593077, 88.4238494, 35.1, 54.089298248291016],
    "00:14": [22.9593113, 88.4238532, 25.8, 43.59755325317383],
    "00:15": [22.9593113, 88.4238532, 25.8, 43.59755325317383],
    "00:16": [22.9593113, 88.4238532, 25.8, 43.59755325317383],
    "00:17": [22.9593113, 88.4238532, 25.8, 43.59755325317383],
    "00:18": [22.9593131, 88.4238552, 27.3, 28.091503143310547],
    "00:19": [22.9593131, 88.4238552, 27.3, 28.091503143310547],
    "00:20": [22.9593131, 88.4238552, 27.3, 28.091503143310547],
    "00:21": [22.9593131, 88.4238552, 27.3, 28.091503143310547],
    "00:22": [22.9593131, 88.4238552, 27.3, 28.091503143310547],
    "00:23": [22.9593124, 88.4238551, 27.3, 322.9293212890625],
    "00:24": [22.9593124, 88.4238551, 27.3, 322.9293212890625],
    "00:25": [22.9593124, 88.4238551, 27.3, 322.9293212890625],
    "00:26": [22.9593123, 88.4238538, 16.5, 264.2221984863281],
    "00:27": [22.9593123, 88.4238538, 16.5, 264.2221984863281],
    "00:28": [22.9593123, 88.4238538, 16.5, 264.2221984863281],
    "00:29": [22.9593133, 88.4238579, 15.3, 68.72982025146484],
    "00:30": [22.9593133, 88.4238579, 15.3, 68.72982025146484],
    "00:31": [22.9593133, 88.4238579, 15.3, 68.72982025146484],
    "00:32": [22.9593179, 88.4238647, 15.3, 57.943992614746094],
    "00:33": [22.9593179, 88.4238647, 15.3, 57.943992614746094],
    "00:34": [22.9593179, 88.4238647, 15.3, 57.943992614746094],
    "00:35": [22.9593193, 88.4238638, 15.3, 80.69071197509766],
    "00:36": [22.9593193, 88.4238638, 15.3, 80.69071197509766],
    "00:37": [22.9593193, 88.4238638, 15.3, 80.69071197509766],
    "00:38": [22.9593183, 88.4238641, 15.3, 154.1818389892578],
    "00:39": [22.9593183, 88.4238641, 15.3, 154.1818389892578],
    "00:40": [22.9593183, 88.4238641, 15.3, 154.1818389892578],
    "00:41": [22.9592592, 88.4239833, 15.6, 135.06060791015625],
    "00:42": [22.9592592, 88.4239833, 15.6, 135.06060791015625],
    "00:43": [22.9592592, 88.4239833, 15.6, 135.06060791015625],
    "00:44": [22.9592616, 88.423978, 15.6, 90.00257873535156],
    "00:45": [22.9592616, 88.423978, 15.6, 90.00257873535156],
    "00:46": [22.9592616, 88.423978, 15.6, 90.00257873535156],
    "00:47": [22.9591663, 88.4242037, 15.6, 168.3014678955078],
    "00:48": [22.9591663, 88.4242037, 15.6, 168.3014678955078],
    "00:49": [22.9591663, 88.4242037, 15.6, 168.3014678955078],
    "00:50": [22.9591663, 88.4242037, 15.6, 168.3014678955078],
    "00:51": [22.9591663, 88.4242037, 15.6, 168.3014678955078],
    "00:52": [22.9591263, 88.4248257, 15.6, 107.22433471679688],
    "00:53": [22.9591263, 88.4248257, 15.6, 107.22433471679688],
    "00:54": [22.9591263, 88.4248257, 15.6, 107.22433471679688],
    "00:55": [22.9591263, 88.4248257, 15.6, 107.22433471679688],
    "00:56": [22.9591263, 88.4248257, 15.6, 107.22433471679688],
    "00:57": [22.9591502, 88.4249735, 15.6, 71.24398040771484],
    "00:58": [22.9591502, 88.4249735, 15.6, 71.24398040771484],
    "00:59": [22.9591502, 88.4249735, 15.6, 71.24398040771484],
    "01:00": [22.9591502, 88.4249735, 15.6, 71.24398040771484],
    "01:01": [22.9591502, 88.4249735, 15.6, 71.24398040771484],
    "01:02": [22.9592574, 88.425031, 15.6, 45.95794677734375],
    "01:03": [22.9592574, 88.425031, 15.6, 45.95794677734375],
    "01:04": [22.9592574, 88.425031, 15.6, 45.95794677734375],
    "01:05": [22.9592574, 88.425031, 15.6, 45.95794677734375],
    "01:06": [22.9592574, 88.425031, 15.6, 45.95794677734375],
    "01:07": [22.9593232, 88.4250472, 15.6, 7.025245189666748],
    "01:08": [22.9593976, 88.4250509, 15.6, 10.066338539123535],
    "01:09": [22.9593976, 88.4250509, 15.6, 10.066338539123535],
    "01:10": [22.9593976, 88.4250509, 15.6, 10.066338539123535],
    "01:11": [22.9593976, 88.4250509, 15.6, 10.066338539123535],
    "01:12": [22.9595126, 88.4250446, 15.6, 343.3546447753906],
    "01:13": [22.9595126, 88.4250446, 15.6, 343.3546447753906],
    "01:14": [22.9595537, 88.4250231, 15.6, 355.9515380859375],
    "01:15": [22.9595537, 88.4250231, 15.6, 355.9515380859375],
    "01:16": [22.9595537, 88.4250231, 15.6, 355.9515380859375],
    "01:17": [22.9596038, 88.425021, 15.6, 359.3999938964844],
    "01:18": [22.9596038, 88.425021, 15.6, 359.3999938964844],
    "01:19": [22.9596038, 88.425021, 15.6, 359.3999938964844],
    "01:20": [22.9596185, 88.4250214, 13.8, 359.0972595214844],
    "01:21": [22.9596185, 88.4250214, 13.8, 359.0972595214844],
    "01:22": [22.9596185, 88.4250214, 13.8, 359.0972595214844],
    "01:23": [22.9596334, 88.4250342, 13.8, 10.077865600585938],
    "01:24": [22.9596334, 88.4250342, 13.8, 10.077865600585938],
    "01:25": [22.9596334, 88.4250342, 13.8, 10.077865600585938],
    "01:26": [22.9596575, 88.4250477, 10.3, 11.079812049865723],
    "01:27": [22.9596575, 88.4250477, 10.3, 11.079812049865723],
    "01:28": [22.9596725, 88.4250564, 10.3, 14.13765811920166],
    "01:29": [22.9596725, 88.4250564, 10.3, 14.13765811920166],
    "01:30": [22.9596725, 88.4250564, 10.3, 14.13765811920166],
    "01:31": [22.9597018, 88.4250668, 11.7, 11.975008010864258],
    "01:32": [22.9597018, 88.4250668, 11.7, 11.975008010864258],
    "01:33": [22.9597018, 88.4250668, 11.7, 11.975008010864258],
    "01:34": [22.9597544, 88.425085, 7.8, 18.11676025390625],
    "01:35": [22.9597544, 88.425085, 7.8, 18.11676025390625],
    "01:36": [22.9597544, 88.425085, 7.8, 18.11676025390625],
    "01:37": [22.9598249, 88.4251277, 7.8, 26.881118774414062],
    "01:38": [22.9598249, 88.4251277, 7.8, 26.881118774414062],
    "01:39": [22.9598249, 88.4251277, 7.8, 26.881118774414062],
    "01:40": [22.9598249, 88.4251277, 7.8, 26.881118774414062],
    "01:41": [22.9598249, 88.4251277, 7.8, 26.881118774414062],
    "01:42": [22.9602261, 88.425415, 7.8, 30.374650955200195],
    "01:43": [22.9602261, 88.425415, 7.8, 30.374650955200195],
    "01:44": [22.9602261, 88.425415, 7.8, 30.374650955200195],
    "01:45": [22.9602261, 88.425415, 7.8, 30.374650955200195],
    "01:46": [22.9602261, 88.425415, 7.8, 30.374650955200195],
    "01:47": [22.9606913, 88.4257424, 9.9, 32.931121826171875],
    "01:48": [22.9606913, 88.4257424, 9.9, 32.931121826171875],
    "01:49": [22.9606913, 88.4257424, 9.9, 32.931121826171875],
    "01:50": [22.9606913, 88.4257424, 9.9, 32.931121826171875],
    "01:51": [22.9606913, 88.4257424, 9.9, 32.931121826171875],
    "01:52": [22.961157, 88.4261556, 9.9, 43.73406219482422],
    "01:53": [22.961157, 88.4261556, 9.9, 43.73406219482422],
    "01:54": [22.961157, 88.4261556, 9.9, 43.73406219482422],
    "01:55": [22.961157, 88.4261556, 9.9, 43.73406219482422],
    "01:56": [22.961157, 88.4261556, 9.9, 43.73406219482422],
    "01:57": [22.9614409, 88.4264236, 9.9, 41.996036529541016],
    "01:58": [22.9614409, 88.4264236, 9.9, 41.996036529541016],
    "01:59": [22.9614409, 88.4264236, 9.9, 41.996036529541016],
    "02:00": [22.9614409, 88.4264236, 9.9, 41.996036529541016],
    "02:01": [22.9614409, 88.4264236, 9.9, 41.996036529541016],
    "02:02": [22.9617824, 88.4266959, 11.0, 37.267765045166016],
    "02:03": [22.9617824, 88.4266959, 11.0, 37.267765045166016],
    "02:04": [22.9617824, 88.4266959, 11.0, 37.267765045166016],
    "02:05": [22.9617824, 88.4266959, 11.0, 37.267765045166016],
    "02:06": [22.9617824, 88.4266959, 11.0, 37.267765045166016],
    "02:07": [22.9621015, 88.4269649, 11.0, 37.95014953613281],
    "02:08": [22.9621015, 88.4269649, 11.0, 37.95014953613281],
    "02:09": [22.9621015, 88.4269649, 11.0, 37.95014953613281],
    "02:10": [22.9622723, 88.4270777, 11.0, 30.681079864501953],
    "02:11": [22.9622723, 88.4270777, 11.0, 30.681079864501953],
    "02:12": [22.9622723, 88.4270777, 11.0, 30.681079864501953],
    "02:13": [22.9623924, 88.4271387, 11.0, 39.19194793701172],
    "02:14": [22.9623924, 88.4271387, 11.0, 39.19194793701172],
    "02:15": [22.9623924, 88.4271387, 11.0, 39.19194793701172],
    "02:16": [22.9623924, 88.4271387, 11.0, 39.19194793701172],
    "02:17": [22.9626626, 88.4273147, 11.0, 36.944820404052734],
    "02:18": [22.9626626, 88.4273147, 11.0, 36.944820404052734],
    "02:19": [22.9626626, 88.4273147, 11.0, 36.944820404052734],
    "02:20": [22.9626626, 88.4273147, 11.0, 36.944820404052734],
    "02:21": [22.9626626, 88.4273147, 11.0, 36.944820404052734],
    "02:22": [22.9626626, 88.4273147, 11.0, 36.944820404052734],
    "02:23": [22.9626626, 88.4273147, 11.0, 36.944820404052734],
    "02:24": [22.9626626, 88.4273147, 11.0, 36.944820404052734],
    "02:25": [22.9626626, 88.4273147, 11.0, 36.944820404052734],
    "02:26": [22.9626626, 88.4273147, 11.0, 36.944820404052734],
    "02:27": [22.9631864, 88.4277577, 11.0, 40.077850341796875],
    "02:28": [22.9631864, 88.4277577, 11.0, 40.077850341796875],
    "02:29": [22.9631864, 88.4277577, 11.0, 40.077850341796875],
    "02:30": [22.9632904, 88.4278801, 11.0, 49.28691482543945],
    "02:31": [22.9632904, 88.4278801, 11.0, 49.28691482543945],
    "02:32": [22.9632904, 88.4278801, 11.0, 49.28691482543945],
    "02:33": [22.9632415, 88.4279222, 14.0, 67.8924331665039],
    "02:34": [22.9632415, 88.4279222, 14.0, 67.8924331665039],
    "02:35": [22.9632415, 88.4279222, 14.0, 67.8924331665039],
    "02:36": [22.9631654, 88.4279002, 14.0, 76.81334686279297],
    "02:37": [22.9631654, 88.4279002, 14.0, 76.81334686279297],
    "02:38": [22.9631654, 88.4279002, 14.0, 76.81334686279297],
    "02:39": [22.9631721, 88.4279538, 14.0, 77.15001678466797],
    "02:40": [22.9631721, 88.4279538, 14.0, 77.15001678466797],
    "02:41": [22.9631721, 88.4279538, 14.0, 77.15001678466797],
    "02:42": [22.9631721, 88.4279538, 14.0, 77.15001678466797],
    "02:43": [22.9631721, 88.4279538, 14.0, 77.15001678466797],
    "02:44": [22.9631237, 88.4280449, 14.0, 90.82279205322266],
    "02:45": [22.9631237, 88.4280449, 14.0, 90.82279205322266],
    "02:46": [22.9631237, 88.4280449, 14.0, 90.82279205322266],
    "02:47": [22.9631094, 88.4280724, 24.6, 257.20074462890625],
    "02:48": [22.9631094, 88.4280724, 24.6, 257.20074462890625],
    "02:49": [22.9631094, 88.4280724, 24.6, 257.20074462890625],
    "02:50": [22.9630959, 88.4280099, 24.6, 263.6425476074219],
    "02:51": [22.9630959, 88.4280099, 24.6, 263.6425476074219],
    "02:52": [22.9630959, 88.4280099, 24.6, 263.6425476074219],
    "02:53": [22.9630837, 88.4279903, 24.6, 236.03387451171875],
    "02:54": [22.9630837, 88.4279903, 24.6, 236.03387451171875],
    "02:55": [22.9630218, 88.4281243, 25.3, 109.93315887451172],
    "02:56": [22.9630218, 88.4281243, 25.3, 109.93315887451172],
    "02:57": [22.9630218, 88.4281243, 25.3, 109.93315887451172],
    "02:58": [22.9630218, 88.4281243, 25.3, 109.93315887451172],
    "02:59": [22.9629543, 88.4283024, 25.3, 117.29852294921875],
    "03:00": [22.9629543, 88.4283024, 25.3, 117.29852294921875],
    "03:01": [22.9629543, 88.4283024, 25.3, 117.29852294921875],
    "03:02": [22.962889, 88.4283515, 25.3, 194.99038696289062],
    "03:03": [22.962889, 88.4283515, 25.3, 194.99038696289062],
    "03:04": [22.962889, 88.4283515, 25.3, 194.99038696289062],
    "03:05": [22.962793, 88.4283914, 25.3, 180.7506561279297],
    "03:06": [22.962793, 88.4283914, 25.3, 180.7506561279297],
    "03:07": [22.962793, 88.4283914, 25.3, 180.7506561279297],
    "03:08": [22.9627251, 88.428447, 25.3, 200.28672790527344],
    "03:09": [22.9627251, 88.428447, 25.3, 200.28672790527344],
    "03:10": [22.9627251, 88.428447, 25.3, 200.28672790527344],
    "03:11": [22.9626765, 88.428482, 29.6, 190.37619018554688],
    "03:12": [22.9626765, 88.428482, 29.6, 190.37619018554688],
    "03:13": [22.9626765, 88.428482, 29.6, 190.37619018554688],
    "03:14": [22.962628, 88.4287642, 29.6, 96.60751342773438],
    "03:15": [22.962628, 88.4287642, 29.6, 96.60751342773438],
    "03:16": [22.962628, 88.4287642, 29.6, 96.60751342773438],
    "03:17": [22.962628, 88.4287642, 29.6, 96.60751342773438],
    "03:18": [22.962628, 88.4287642, 29.6, 96.60751342773438],
    "03:19": [22.9625485, 88.4293806, 29.6, 99.02837371826172],
    "03:20": [22.9625485, 88.4293806, 29.6, 99.02837371826172],
    "03:21": [22.9625485, 88.4293806, 29.6, 99.02837371826172],
    "03:22": [22.9625485, 88.4293806, 29.6, 99.02837371826172],
    "03:23": [22.9625485, 88.4293806, 29.6, 99.02837371826172],
    "03:24": [22.9624668, 88.4293879, 27.0, 121.04792785644531],
    "03:25": [22.9624668, 88.4293879, 27.0, 121.04792785644531],
    "03:26": [22.9624668, 88.4293879, 27.0, 121.04792785644531],
    "03:27": [22.9624668, 88.4293879, 27.0, 121.04792785644531],
    "03:28": [22.9624668, 88.4293879, 27.0, 121.04792785644531],
    "03:29": [22.962292, 88.4298186, 26.9, 113.80213928222656],
    "03:30": [22.962292, 88.4298186, 26.9, 113.80213928222656],
    "03:31": [22.962292, 88.4298186, 26.9, 113.80213928222656],
    "03:32": [22.962292, 88.4298186, 26.9, 113.80213928222656],
    "03:33": [22.962292, 88.4298186, 26.9, 113.80213928222656],
    "03:34": [22.9622889, 88.430325, 26.9, 97.98789978027344],
    "03:35": [22.9622889, 88.430325, 26.9, 97.98789978027344],
    "03:36": [22.9622889, 88.430325, 26.9, 97.98789978027344],
    "03:37": [22.9622889, 88.430325, 26.9, 97.98789978027344],
    "03:38": [22.9622889, 88.430325, 26.9, 97.98789978027344],
    "03:39": [22.9623307, 88.4304528, 26.9, 102.74198150634766],
    "03:40": [22.9623307, 88.4304528, 26.9, 102.74198150634766],
    "03:41": [22.9623307, 88.4304528, 26.9, 102.74198150634766],
    "03:42": [22.9623307, 88.4304528, 26.9, 102.74198150634766],
    "03:43": [22.9623307, 88.4304528, 26.9, 102.74198150634766],
    "03:44": [22.96228, 88.4307272, 26.9, 102.66941833496094],
    "03:45": [22.96228, 88.4307272, 26.9, 102.66941833496094],
    "03:46": [22.96228, 88.4307272, 26.9, 102.66941833496094],
    "03:47": [22.96228, 88.4307272, 26.9, 102.66941833496094],
    "03:48": [22.96228, 88.4307272, 26.9, 102.66941833496094],
    "03:49": [22.9620792, 88.431303, 28.9, 110.8634033203125],
    "03:50": [22.9620792, 88.431303, 28.9, 110.8634033203125],
    "03:51": [22.9620792, 88.431303, 28.9, 110.8634033203125],
    "03:52": [22.9620792, 88.431303, 28.9, 110.8634033203125],
    "03:53": [22.9620792, 88.431303, 28.9, 110.8634033203125],
    "03:54": [22.9618941, 88.4317814, 28.9, 111.06533813476562],
    "03:55": [22.9618941, 88.4317814, 28.9, 111.06533813476562],
    "03:56": [22.9618941, 88.4317814, 28.9, 111.06533813476562],
    "03:57": [22.9618941, 88.4317814, 28.9, 111.06533813476562],
    "03:58": [22.9618941, 88.4317814, 28.9, 111.06533813476562],
    "03:59": [22.9617994, 88.4321418, 28.9, 106.18110656738281],
    "04:00": [22.9617994, 88.4321418, 28.9, 106.18110656738281],
    "04:01": [22.9617994, 88.4321418, 28.9, 106.18110656738281],
    "04:02": [22.9617994, 88.4321418, 28.9, 106.18110656738281],
    "04:03": [22.9617994, 88.4321418, 28.9, 106.18110656738281],
    "04:04": [22.9618333, 88.4322913, 28.9, 94.16120910644531],
    "04:05": [22.9618333, 88.4322913, 28.9, 94.16120910644531],
    "04:06": [22.9618333, 88.4322913, 28.9, 94.16120910644531],
    "04:07": [22.9618333, 88.4322913, 28.9, 94.16120910644531],
    "04:08": [22.9618333, 88.4322913, 28.9, 94.16120910644531],
    "04:09": [22.9618088, 88.4324584, 28.9, 94.81388854980469],
    "04:10": [22.9618088, 88.4324584, 28.9, 94.81388854980469],
    "04:11": [22.9618088, 88.4324584, 28.9, 94.81388854980469],
    "04:12": [22.9618088, 88.4324584, 28.9, 94.81388854980469],
    "04:13": [22.9618088, 88.4324584, 28.9, 94.81388854980469],
    "04:14": [22.9617876, 88.4325589, 28.9, 97.41891479492188],
    "04:15": [22.9617464, 88.4325838, 28.9, 90.2245101928711],
    "04:16": [22.9617464, 88.4325838, 28.9, 90.2245101928711],
    "04:17": [22.9617464, 88.4325838, 28.9, 90.2245101928711],
    "04:18": [22.9617464, 88.4325838, 28.9, 90.2245101928711],
    "04:19": [22.9616741, 88.4327514, 28.9, 90.14936065673828],
    "04:20": [22.9616741, 88.4327514, 28.9, 90.14936065673828],
    "04:21": [22.9616741, 88.4327514, 28.9, 90.14936065673828],
    "04:22": [22.9616741, 88.4327514, 28.9, 90.14936065673828],
    "04:23": [22.9616741, 88.4327514, 28.9, 90.14936065673828],
    "04:24": [22.9616439, 88.4328201, 28.9, 93.8611068725586],
    "04:25": [22.9616439, 88.4328201, 28.9, 93.8611068725586],
    "04:26": [22.9616439, 88.4328201, 28.9, 93.8611068725586],
    "04:27": [22.9616439, 88.4328201, 28.9, 93.8611068725586],
    "04:28": [22.9616439, 88.4328201, 28.9, 93.8611068725586],
    "04:29": [22.9616439, 88.4328201, 28.9, 93.8611068725586],
    "04:30": [22.9616439, 88.4328201, 28.9, 93.8611068725586],
    "04:31": [22.961664, 88.4329695, 28.9, 111.83136749267578],
    "04:32": [22.961664, 88.4329695, 28.9, 111.83136749267578],
    "04:33": [22.961664, 88.4329695, 28.9, 111.83136749267578],
    "04:34": [22.961664, 88.4329695, 28.9, 111.83136749267578],
    "04:35": [22.961664, 88.4329695, 28.9, 111.83136749267578],
    "04:36": [22.9616291, 88.4331355, 15.7, 102.97984313964844],
    "04:37": [22.9616291, 88.4331355, 15.7, 102.97984313964844],
    "04:38": [22.9616291, 88.4331355, 15.7, 102.97984313964844],
    "04:39": [22.9616291, 88.4331355, 15.7, 102.97984313964844],
    "04:40": [22.9616291, 88.4331355, 15.7, 102.97984313964844],
    "04:41": [22.9616317, 88.4332336, 15.7, 90.0000991821289],
    "04:42": [22.9616317, 88.4332336, 15.7, 90.0000991821289],
    "04:43": [22.9616317, 88.4332336, 15.7, 90.0000991821289],
    "04:44": [22.9616317, 88.4332336, 15.7, 90.0000991821289],
    "04:45": [22.9616317, 88.4332336, 15.7, 90.0000991821289],
    "04:46": [22.9616469, 88.4332997, 15.7, 77.13127899169922],
    "04:47": [22.9616469, 88.4332997, 15.7, 77.13127899169922],
    "04:48": [22.9616469, 88.4332997, 15.7, 77.13127899169922],
    "04:49": [22.9616469, 88.4332997, 15.7, 77.13127899169922],
    "04:50": [22.9616469, 88.4332997, 15.7, 77.13127899169922],
    "04:51": [22.9616371, 88.4332726, 15.7, 326.76348876953125],
    "04:52": [22.9616356, 88.4332533, 15.7, 286.18865966796875],
    "04:53": [22.9616356, 88.4332533, 15.7, 286.18865966796875],
    "04:54": [22.9616356, 88.4332533, 15.7, 286.18865966796875],
    "04:55": [22.9616356, 88.4332533, 15.7, 286.18865966796875],
    "04:56": [22.9616129, 88.4331954, 15.7, 253.8794708251953],
    "04:57": [22.9616129, 88.4331954, 15.7, 253.8794708251953],
    "04:58": [22.9616129, 88.4331954, 15.7, 253.8794708251953],
    "04:59": [22.9616129, 88.4331954, 15.7, 253.8794708251953],
    "05:00": [22.9616129, 88.4331954, 15.7, 253.8794708251953],
    "05:01": [22.9615648, 88.4331368, 15.7, 242.9983673095703],
    "05:02": [22.9615648, 88.4331368, 15.7, 242.9983673095703],
    "05:03": [22.9615648, 88.4331368, 15.7, 242.9983673095703],
    "05:04": [22.9615648, 88.4331368, 15.7, 242.9983673095703],
    "05:05": [22.9615648, 88.4331368, 15.7, 242.9983673095703],
    "05:06": [22.9614865, 88.4332414, 15.7, 109.99726104736328],
    "05:07": [22.9614865, 88.4332414, 15.7, 109.99726104736328],
    "05:08": [22.9614865, 88.4332414, 15.7, 109.99726104736328],
    "05:09": [22.9614865, 88.4332414, 15.7, 109.99726104736328],
    "05:10": [22.9614865, 88.4332414, 15.7, 109.99726104736328],
    "05:11": [22.9614061, 88.4334379, 15.7, 90.0],
    "05:12": [22.9614061, 88.4334379, 15.7, 90.0],
    "05:13": [22.9614061, 88.4334379, 15.7, 90.0],
    "05:14": [22.9614061, 88.4334379, 15.7, 90.0],
    "05:15": [22.9614061, 88.4334379, 15.7, 90.0],
    "05:16": [22.9613752, 88.4335106, 5.5, 138.11705017089844],
    "05:17": [22.9613752, 88.4335106, 5.5, 138.11705017089844],
    "05:18": [22.9613752, 88.4335106, 5.5, 138.11705017089844],
    "05:19": [22.9613752, 88.4335106, 5.5, 138.11705017089844],
    "05:20": [22.9613752, 88.4335106, 5.5, 138.11705017089844],
    "05:21": [22.9614833, 88.4336602, 5.5, 122.06124114990234],
    "05:22": [22.9614833, 88.4336602, 5.5, 122.06124114990234],
    "05:23": [22.9614833, 88.4336602, 5.5, 122.06124114990234],
    "05:24": [22.9614465, 88.4336799, 5.5, 284.3071594238281],
    "05:25": [22.9614465, 88.4336799, 5.5, 284.3071594238281],
    "05:26": [22.9614465, 88.4336799, 5.5, 284.3071594238281],
    "05:27": [22.9613779, 88.4336688, 5.5, 181.16793823242188],
    "05:28": [22.9613779, 88.4336688, 5.5, 181.16793823242188],
    "05:29": [22.9613779, 88.4336688, 5.5, 181.16793823242188],
    "05:30": [22.9613779, 88.4336688, 5.5, 181.16793823242188],
    "05:31": [22.9612905, 88.4336455, 5.5, 188.98092651367188],
    "05:32": [22.9612905, 88.4336455, 5.5, 188.98092651367188],
    "05:33": [22.9612905, 88.4336455, 5.5, 188.98092651367188],
    "05:34": [22.9613034, 88.4336292, 5.5, 353.1160888671875],
    "05:35": [22.9613034, 88.4336292, 5.5, 353.1160888671875],
    "05:36": [22.9613034, 88.4336292, 5.5, 353.1160888671875]
  };*/

}