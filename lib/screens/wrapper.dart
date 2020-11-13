
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wellbeing_app/models/apps.dart';
import 'package:wellbeing_app/screens/home/home.dart';
import 'package:wellbeing_app/screens/settings/settings.dart';
import 'package:wellbeing_app/screens/timer/timer.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  List<Apps> initialApps = []
    ..add(Apps(
        id: 0,
        name: "Instagram",
        monitor: false,
        listName: "instagram",
        time: 0,
        timeLimit: new Duration(hours: 2, minutes: 5)))
    ..add(Apps(
        id: 1,
        name: "Snapchat",
        monitor: false,
        listName: "snapchat",
        time: 0,
        timeLimit: new Duration(hours: 2, minutes: 10)))
    ..add(Apps(
        id: 2,
        name: "Youtube",
        monitor: false,
        listName: "youtube",
        time: 0,
        timeLimit: new Duration(hours: 2, minutes: 15)));

  int _currentIndex = 1;
  final List<Widget> _children = [
    Timer(),
    Home(),
    Settings(),
  ];

  void initState() {
    storage.readCounter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('etu'),
        backgroundColor: Color(0xFF6200EE), //Colors.lightBlue[300],
        elevation: 0.0,
        actions: [
          FlatButton.icon(
            onPressed: null,
            icon: FaIcon(FontAwesomeIcons.coins),
            label: Text('24'),
          )
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex, // this will be set when a new tab is tapped
        showSelectedLabels: false,
        showUnselectedLabels: false,  
        items: [
         BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Timer'
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
     ),
    );
  }

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }

}
