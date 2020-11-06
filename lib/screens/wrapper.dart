
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wellbeing_app/screens/home/home.dart';
import 'package:wellbeing_app/screens/settings/settings.dart';
import 'package:wellbeing_app/screens/timer/timer.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

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
        backgroundColor: Colors.lightBlue[300],
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
       items: [
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
     ),
    );
  }

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }

}
