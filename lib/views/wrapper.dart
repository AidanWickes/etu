
import 'package:flutter/material.dart';
import 'package:wellbeing_app/views/home/home.dart';
import 'package:wellbeing_app/views/settings/settings.dart';
import 'package:wellbeing_app/views/timer/timer.dart';

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
            icon: Icon(Icons.attach_money),
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
