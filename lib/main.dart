import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wellbeing_app/screens/wrapper.dart';
import 'package:wellbeing_app/isolates/timer.dart';

import 'controllers/storage.dart';
import 'models/apps.dart';

var timer = new CountdownTimer();
var storage = new CounterStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var isStorage = await storage.readCounter();
  if (isStorage[0] == "Error") {
    await storage.writeCounter(jsonEncode(initialApps));
  }
  await storage.readCounter();
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
          bodyText2: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
              color: Color(0xFF083D77)),
        ),
      ),
      home: Wrapper(),
    );
  }
}
