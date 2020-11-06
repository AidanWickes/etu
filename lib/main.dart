import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:app_usage/app_usage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

final prefs = SharedPreferences.getInstance();

var apps = [
  { "name": "Instagram", "monitor": false, "listName": "instagram", "time": 0 },
  { "name": "Snapchat", "monitor": false, "listName": "snapchat", "time": 0},
  { "name": "Youtube", "monitor": false, "listName": "youtube", "time": 0}
  ];

class MyApp extends StatefulWidget {

  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<EventUsageInfo> events = [];
  int _selectedIndex = 1;

  final CounterStorage storage = CounterStorage();
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 1: Timer',
      style: optionStyle,
    ),
    Scaffold(
        body: Usage()
    ),
    Scaffold(
        body: Settings()
    ),

  ];

  @override
  void initState() {
    storage.readCounter();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("HEY0")
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Timer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Options',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      )
      );
  }
}


class Usage extends StatefulWidget {

  @override
  _UsageAppState createState() => _UsageAppState();
}

class _UsageAppState extends State<Usage>{
  List<EventUsageInfo> events = [];
  List<AppUsageInfo> _infos = [];

  @override
  void initState() {
    initUsage();
    super.initState();
  }

  Future<void> initUsage() async {
    // UsageStats.grantUsagePermission();
    // DateTime endDate = new DateTime.now();
    // DateTime startDate = endDate.subtract(new Duration(days: 1));
    // List<EventUsageInfo> queryEvents =
    // await UsageStats.queryEvents(startDate, endDate);
    //
    // this.setState(() {
    //   events = queryEvents.reversed.toList();
    // });

    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(new Duration(days: 1));
      List<AppUsageInfo> infos = await AppUsage.getAppUsage(startDate, endDate);
      setState(() {
        _infos.clear();
        infos.forEach((element) {
          apps.forEach((appElement) {
            if (element.packageName == appElement["listName"] && appElement["monitor"]){
              appElement["time"] =  element.usage.toString();
              return _infos.add(element);
            } else if (appElement["listName"] == "youtube"){
              if (element.appName == appElement["listName"] && appElement["monitor"]){
                appElement["time"] = element.usage.toString();
                return _infos.add(element);
              }
            }
          });
          // if (element.packageName == "google" && element.appName == "youtube" || element.packageName == "instagram" || element.packageName == "snapchat"){
          //   return _infos.add(element);
          // }
        });
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            if (apps[index]["monitor"]){
              return ListTile(
                  title: Text(apps[index]["name"]),
                  trailing: Text(apps[index]["time"].toString()));
            } else {
              return SizedBox.shrink();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          initUsage();
        },
        child: Icon(
          Icons.refresh,
        ),
        mini: true,
      ),
    );
  }
}

class Settings extends StatefulWidget {

  @override
  _SettingsApp createState() => _SettingsApp();
}

class _SettingsApp extends State<Settings>{

  final CounterStorage storage = CounterStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(apps[index]["name"]),
                trailing: Switch(
                  value: apps[index]["monitor"],
                  onChanged: (value) {
                  setState(() {
                    apps[index]["monitor"] = value;
                  });
                  storage.writeCounter(jsonEncode(apps));
                },
              )
            );
          }),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/apps.json');
  }

  Future<List> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      var test = jsonDecode(contents);

   //   apps = test;
      var i = 0;
      test.forEach((element) {
        apps[i] = element;
        i++;
      });
      return test;
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  Future<File> writeCounter(counter) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$counter');
  }
}