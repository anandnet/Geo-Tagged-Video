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
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        //color: Colors.redAccent,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Image.asset(
                  "assets/appicon1.png",
                  width: mq.size.width / 2 - 10,
                  height: mq.size.height * .75,
                ),
              ),
              Container(
                height: mq.size.height * .24,
                child: Center(
                  child: Text(
                    "GeoCam",
                    style: TextStyle(fontSize: 45, color: Colors.grey),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
