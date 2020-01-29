import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './providers/video_data.dart';
import 'package:provider/provider.dart';
import './screens/video_recorder_screen.dart';
import './screens/video_player_screen.dart';
import './screens/home_screen.dart';
import './screens/video_list_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Map<int, Color> color = {
    50: Color.fromRGBO(0, 64, 129, .1),
    100: Color.fromRGBO(0, 64, 129, .2),
    200: Color.fromRGBO(0, 64, 129, .3),
    300: Color.fromRGBO(0, 64, 129, .4),
    400: Color.fromRGBO(0, 64, 129, .5),
    500: Color.fromRGBO(0, 64, 129, .6),
    600: Color.fromRGBO(0, 64, 129, .7),
    700: Color.fromRGBO(0, 64, 129, .8),
    800: Color.fromRGBO(0, 64, 129, .9),
    900: Color.fromRGBO(0, 64, 129, 1),
  };
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (context) => VideoDataProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GeoCam',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF004081, color),
        ),
        home: SplashScreen(),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          VideoPlayerScreen.routeName: (context) => VideoPlayerScreen(),
          VideoRecorderScreen.routeName: (context) => VideoRecorderScreen(),
          VideosListScreen.routeName: (context) => VideosListScreen()
        },
      ),
    );
  }
}
