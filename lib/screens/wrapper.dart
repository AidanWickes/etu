import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/settingsModel.dart' as metaData;
import 'package:wellbeing_app/screens/home/homeGrid.dart';
import 'package:wellbeing_app/screens/home/homeGridTemp.dart';
import 'package:wellbeing_app/screens/settings/settings.dart';
import 'package:wellbeing_app/screens/timer/timer.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  var storage = new CounterStorage();
  int _currentIndex = 1;
  final List<Widget> _children = [
    Timer(),
    HomeGrid(),
    Settings(),
  ];

  void initState() {
    storage.readCounter();
    super.initState();
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                Center(
                  child: FlatButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          side: BorderSide(color: Color(0xFF2CA5B5))),
                      color: Color(0xFF2CA5B5),
                      // padding: EdgeInsets.all(10.0),
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.coins,
                          size: 20, color: Color(0xFFE8CE22)),
                      label: Text(metaData.settings.totalPoints.toString(),
                          style: TextStyle(
                              color: Color(0xFFE8CE22),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito',
                              fontSize: 25))),
                ),
                Text("Consequence & Reward Log"),
                TextButton(onPressed: null, child: Text("Redeem")),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.instagram,
                          color: Colors.pink,
                          size: 24.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ),
                      Expanded(child: Text("Timer Exceeded")),
                      Text("-6")
                    ]),
                  ),
                ),
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
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
              FlatButton.icon(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(100.0),
                  //     side: BorderSide(color: Color(0xFF2CA5B5))),
                  // color: Color(0xFF2CA5B5),
                  // padding: EdgeInsets.all(10.0),
                  onPressed: () => displayBottomSheet(context),
                  icon: FaIcon(FontAwesomeIcons.coins,
                      size: 20, color: Color(0xFFE8CE22)),
                  label: Text(metaData.settings.totalPoints.toString(),
                      style: TextStyle(
                          color: Color(0xFFE8CE22),
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Nunito',
                          fontSize: 25)))
            ],
          )),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF083D77),
        onTap: onTabTapped,
        showSelectedLabels: false, //hiding labels
        showUnselectedLabels: false,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidClock,
                size: 35, color: Color(0xFF2CA5B5)),
            activeIcon: FaIcon(FontAwesomeIcons.solidClock,
                size: 35, color: Color(0xFF9FE79C)),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/bubblesIcon.png", height: 55),
            activeIcon:
                Image.asset("assets/images/bubblesIconActive.png", height: 55),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.cog,
                size: 35, color: Color(0xFF2CA5B5)),
            activeIcon: FaIcon(FontAwesomeIcons.cog,
                size: 35, color: Color(0xFF9FE79C)),
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
