import 'package:flutter/material.dart';
import 'dart:async';
import 'package:usage_stats/usage_stats.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<EventUsageInfo> events = [];
  int _selectedIndex = 1;

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
    Text(
      'Index 2: Options',
      style: optionStyle,
    ),

  ];

  @override
  void initState() {
    initUsage();
    super.initState();
  }

  Future<void> initUsage() async {
    UsageStats.grantUsagePermission();
    DateTime endDate = new DateTime.now();
    DateTime startDate = endDate.subtract(new Duration(days: 1));
    List<EventUsageInfo> queryEvents =
        await UsageStats.queryEvents(startDate, endDate);

    this.setState(() {
      events = queryEvents.reversed.toList();
    });
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            initUsage();
          },
          child: Icon(
            Icons.refresh,
          ),
          mini: true,
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

  @override
  void initState() {
    initUsage();
    super.initState();
  }

  Future<void> initUsage() async {
    UsageStats.grantUsagePermission();
    DateTime endDate = new DateTime.now();
    DateTime startDate = DateTime(endDate.year, endDate.month, 26, 13, 58, 0);
    List<EventUsageInfo> queryEvents =
    await UsageStats.queryEvents(startDate, endDate);

    this.setState(() {
      events = queryEvents.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(events[index].packageName),
                    subtitle: Text(
                        "Last time used: ${DateTime.fromMillisecondsSinceEpoch(int.parse(events[index].timeStamp)).toIso8601String()}"),
                    trailing: Text(events[index].eventType),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: events.length)),
    );
  }
}
