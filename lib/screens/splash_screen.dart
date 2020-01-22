import 'dart:async';
import '../screens/home_screen.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(
     builder:(context)=>HomeScreen(),
    )));
  }
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq=MediaQuery.of(context);
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.yellow,
                Colors.red.withOpacity(0.9),
                Colors.blue,
                ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
            ),
          ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:<Widget>[ Center(
            child: CircleAvatar(
              radius: mq.size.width/2-10,
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.camera,
              color: Colors.white,
              size: 250,
              )
            ),
          ),
          Text(
            "GeoCam",
            style: TextStyle(
              fontFamily: "Exo",
              fontSize: 55,
            ),
          ),
        ]
        ),
      ),
    );
  }
}