import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wellbeing_app/controllers/global.dart';
import 'package:wellbeing_app/controllers/settingsStorage.dart';

import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/apps.dart';
import 'package:wellbeing_app/models/settingsModel.dart' as metaData;
// import 'package:wellbeing_app/screens/home/homeGridTest.dart';
import 'package:wellbeing_app/screens/home/homeGrid.dart';
import 'package:wellbeing_app/screens/settings/settings.dart';
import 'package:wellbeing_app/screens/timer/timer.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> with WidgetsBindingObserver {
  var storage = new CounterStorage();
  int _currentIndex = 1;
  Duration totalTime;
  Duration sum;
  final List<Widget> _children = [
    Timer(),
    HomeGrid(),
    Settings(),
  ];

  bool isShown = true;

  void initState() {
    storage.readCounter();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    showReflectDialog();
  }

  showReflectDialog() {
    sum = new Duration(minutes: 0);
    initialApps.forEach((App app) {
      if (app.monitor && app.time.inMilliseconds > 0 || sum != null) {
        return sum = new Duration(
            milliseconds: sum.inMilliseconds + app.time.inMilliseconds);
      } else if (app.monitor) {
        return sum = new Duration(milliseconds: app.time.inMilliseconds);
      }
    });
    var mIndex = [];
    if (sum != null) {
      if (sum.inMinutes >= 165) {
        mIndex.add(0);
      }
      if (sum.inMinutes >= 120) {
        mIndex.add(1);
        mIndex.add(2);
      }
      if (sum.inMinutes >= 90) {
        mIndex.add(3);
      }
      if (sum.inMinutes >= 60) {
        mIndex.add(4);
        mIndex.add(5);
      }
      if (sum.inMinutes >= 40) {
        mIndex.add(6);
      }
      if (sum.inMinutes >= 30) {
        mIndex.add(7);
      }
      if (sum.inMinutes >= 20) {
        mIndex.add(8);
      }
    }
    if (mIndex.length > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        int message = mIndex[Random().nextInt(mIndex.length)];
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Lets Reflect."),
                  content: new Text(messages[message]),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      if (state == AppLifecycleState.resumed) {
        isShown = true;
        storage.readCounter();
        SettingsStorage().readSettings();
        _currentIndex = 1;
        showReflectDialog();
      } else {
        isShown = false;
      }
    });
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void displayBottomSheet(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new Dialog(
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            // child: Padding(
            //     padding: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              Divider(
                color: Colors.white,
                height: 10,
                indent: 0,
                endIndent: 0,
              ),
              Center(
                child: FlatButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        side: BorderSide(color: Color(0xFF2CA5B5))),
                    color: Color(0xFF2CA5B5),
                    // padding: EdgeInsets.all(10.0),
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.coins,
                        size: 30, color: Color(0xFFE8CE22)),
                    label: Text(metaData.settings.totalPoints.toString(),
                        style: TextStyle(
                            color: Color(0xFFE8CE22),
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Nunito',
                            fontSize: 30))),
              ),
              Divider(
                color: Colors.white,
                height: 10,
                indent: 0,
                endIndent: 0,
              ),
              Text("Consequence & Reward Log"),
              TextButton(
                  onPressed: null,
                  child: Text(
                    "Redeem",
                    style: TextStyle(color: Color(0xFF083D77)),
                  )),
              metaData.settings.history.length > 0
                  ? Column(
                      children: List.generate(metaData.settings.history.length,
                          (index) {
                      return metaData.settings.history[index].monitor
                          ? Padding(
                              padding:
                                  EdgeInsets.only(top: 2, left: 10, right: 10),
                              child: Card(
                                color: Color.fromRGBO(240, 240, 240, 1),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, right: 10),
                                  child: Row(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: getIcon(
                                          metaData.settings.history[index]),
                                    ),
                                    Expanded(
                                        child: metaData.settings.history[index]
                                                .isBroken
                                            ? Text("Timer exceeded")
                                            : Text("Timer achieved")),
                                    metaData.settings.history[index].isBroken
                                        ? Text('-' +
                                            metaData
                                                .settings.history[index].points
                                                .toString())
                                        : Text('+' +
                                            metaData
                                                .settings.history[index].points
                                                .toString()),
                                  ]),
                                ),
                              ))
                          : SizedBox.shrink();
                    }))
                  // children: metaData.settings.history.map((App currentObject) {
                  //   Card(
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Row(children: <Widget>[
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: getIcon(currentObject),
                  //         ),
                  //         Expanded(child: Text("Timer Exceeded")),
                  //         currentObject.isBroken
                  //             ? Text('-' + currentObject.points.toString())
                  //             : Text('+' + currentObject.points.toString()),
                  //       ]),
                  //     ),
                  //   );
                  // }).toList(),
                  // )
                  : SizedBox.shrink(),
            ]))
        //           ),
        );
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
              metaData.settings.rewards
                  ? FlatButton.icon(
                      onPressed: () => displayBottomSheet(context),
                      icon: FaIcon(FontAwesomeIcons.coins,
                          size: 20, color: Color(0xFFE8CE22)),
                      label: Text(metaData.settings.totalPoints.toString(),
                          style: TextStyle(
                              color: Color(0xFFE8CE22),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito',
                              fontSize: 25)))
                  : SizedBox.shrink()
            ],
          )),
      body: isShown ? _children[_currentIndex] : SizedBox.shrink(),
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
