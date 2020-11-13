
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
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: AppBar(
        title: Text(
          'etu',
          style: TextStyle(
            color: Color(0xFF2CA5B5),
            fontWeight: FontWeight.w500,
            fontFamily: 'Quicksand',
            fontSize: 40),
          ),
        backgroundColor: Color(0xFF083D77),
        elevation: 0.0,
        actions: [

          Align(
          alignment: Alignment.centerRight,
          child: Container(
            
            width: 40, 
            height: 40, 
            color: Colors.red, 
            
            ),
          ), 

          FlatButton.icon(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
            side: BorderSide(color: Color(0xFF2CA5B5))),
            color:Color(0xFF2CA5B5),
            padding: EdgeInsets.all(10.0),
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.coins, size: 20, color: Color(0xFFE8CE22)),
            label: Text(
            '24',
            style: TextStyle(
            color: Color(0xFFE8CE22),
            fontWeight: FontWeight.w300,
            fontFamily: 'Nunito',
            fontSize: 25 )
              ),
          )
        ],
  )

      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Color(0xFF083D77),
       onTap: onTabTapped,
       showSelectedLabels: false, //hiding labels
       showUnselectedLabels: false,
       currentIndex: _currentIndex, // this will be set when a new tab is tapped
       items: [
         BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidClock, size: 35, color: Color(0xFF2CA5B5)),
              activeIcon: FaIcon(FontAwesomeIcons.solidClock, size: 35, color: Color(0xFF9FE79C)),
              label: 'Timer',
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/bubblesIcon.png", height:55),
              activeIcon: Image.asset("assets/images/bubblesIconActive.png", height:55),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.cog, size: 35, color: Color(0xFF2CA5B5)),
              activeIcon: FaIcon(FontAwesomeIcons.cog, size: 35, color: Color(0xFF9FE79C)),
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
