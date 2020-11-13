import 'package:flutter/material.dart';
import 'package:wellbeing_app/screens/wrapper.dart';

import 'isolates/timer.dart';

var timer = new CountdownTimer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await timer.start();
  //Timer.main();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Nunito',
        textTheme: TextTheme(
        bodyText2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: Color(0xFF083D77)),
          ),
        ),
      home: Wrapper(),
    );
  }
}
