import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:app_usage/app_usage.dart';

import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/apps.dart';

Duration sum;
var hours;
var minutes;
var seconds;

class HomeGrid extends StatefulWidget {
  @override
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  List<EventUsageInfo> events = [];
  List<AppUsageInfo> _infos = [];

  var storage = new CounterStorage();

  List<App> _trackedApps = [];
  List<App> _orderedApps;
  List sizePerc = [0.0, 2.0, 4.0, 6.0, 8.0, 10.0, 12.0];

  bool loaded = false;

  bool inSession = false;
  String currentApp;
  DateTime dateTime;

  var event;

  @override
  void initState() {
    _trackedApps = initialApps.where((i) => i.monitor == true).toList();
    initUsage();
    super.initState();
  }

  Future<void> refreshApps() async {
    sum = Duration(hours: 0, minutes: 0);
    for (var ii = 0; ii < initialApps.length; ii++) {
      sum = sum + initialApps[ii].time;
    }

    //creates a duplicate list that is ordered by time
    _orderedApps = _trackedApps;
    _orderedApps.sort((b, a) => a.time.compareTo(b.time));

    _trackedApps.sort((a, b) => a.listName.compareTo(b.listName));

    hours = sum.inHours;
    minutes = sum.inMinutes % 60;
    seconds = sum.inSeconds % 60;
    _trackedApps = initialApps.where((i) => i.monitor == true).toList();

    _orderedApps = _trackedApps;
    _orderedApps.sort((b, a) => a.time.compareTo(b.time));

    _trackedApps.sort((a, b) => a.listName.compareTo(b.listName));
  }

  Future<void> initUsage() async {
    UsageStats.grantUsagePermission();
    if (await UsageStats.checkUsagePermission()) {
      var tempApps = initialApps;
      tempApps.forEach((element) {
        element.sessions.clear();
        element.time = new Duration(microseconds: 0);
      });
      var trackedEvents = [];
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(new Duration(
          hours: endDate.hour,
          minutes: endDate.minute,
          seconds: endDate.second,
          milliseconds: endDate.millisecond,
          microseconds: endDate.microsecond));
      var eventTest = await UsageStats.queryEvents(startDate, endDate);
      var eventTest3 = await UsageStats.queryUsageStats(startDate, endDate);
      for (var i = 0; i < eventTest.length; i++) {
        tempApps.forEach((App app) {
          if (eventTest[i].packageName.contains(app.listName) &&
              app.monitor &&
              eventTest[i].eventType == '1') {
            dateTime = DateTime.fromMillisecondsSinceEpoch(
                int.parse(eventTest[i].timeStamp));
            inSession = true;
            currentApp = app.name;
            event = eventTest[i];
            print('session started');
            // if (eventTest[i].eventType == '1') {
            //   print(app.name);
            //   if (app.sessions.length > 0) {
            //     var testTime = new DateTime(DateTime.now().year,
            //         DateTime.now().month, DateTime.now().day);
            //     var lastTime =
            //         testTime.add(app.sessions[app.sessions.length - 1]);
            //     var dif = dateTime.difference(lastTime);
            //     print(dif.toString());
            //     if (dif.inSeconds > 5) {
            //       print('new launch');
            //       app.sessions.add(new Duration(
            //           hours: dateTime.hour,
            //           minutes: dateTime.minute,
            //           seconds: dateTime.second,
            //           microseconds: dateTime.microsecond,
            //           milliseconds: dateTime.millisecond));
            //     }
            //   } else {
            //     app.sessions.add(new Duration(
            //         hours: dateTime.hour,
            //         minutes: dateTime.minute,
            //         seconds: dateTime.second,
            //         microseconds: dateTime.microsecond,
            //         milliseconds: dateTime.millisecond));
            //   }
            // }
          } else if (eventTest[i].eventType != '1' &&
              eventTest[i].packageName.contains(app.listName) &&
              inSession &&
              currentApp == app.name &&
              app.monitor) {
            var newDate = DateTime.fromMillisecondsSinceEpoch(
                int.parse(eventTest[i].timeStamp));
            // app.sessions.add(sessionTime);
            var sessionTime = newDate.difference(dateTime);
            if (sessionTime.inSeconds > 1) {
              app.time = app.time + sessionTime;
              app.sessions.add(sessionTime);
              // trackedEvents.add(eventTest[i]);
              trackedEvents.add(event);
              event = '';
            }
            inSession = false;
            currentApp = '';
            print('session ended');
          }
        });
      }
      setState(() {
        var toStore = [];

        tempApps.forEach((App app) {
          var overTime;
          var dif = app.timeLimit - app.time;
          if (app.timeLimit - app.time < Duration(seconds: 0)) {
            app.isBroken = true;
          } else {
            app.isBroken = false;
          }
          if (app.isBroken) {
            overTime = app.time - app.timeLimit;
          } else {
            overTime = app.timeLimit - app.time;
          }
          app.points = (overTime.inMinutes * 0.2).round();
          if (app.points > 20) {
            app.points = 20;
          } else if (app.points < -20) {
            app.points = -20;
          }
        });

        // for (var i = 0; i < eventTest3.length; i++) {
        // tempApps.forEach((App app) {
        //   if (eventTest3[i].packageName.contains(app.listName) &&
        //       app.monitor) {
        //     var time = new Duration(
        //         milliseconds: int.parse(eventTest3[i].totalTimeInForeground));
        //     app.time = time;
        //     var overTime;
        //     var dif = app.timeLimit - app.time;
        //     if (app.timeLimit - app.time < Duration(seconds: 0)) {
        //       app.isBroken = true;
        //     } else {
        //       app.isBroken = false;
        //     }
        //     if (app.isBroken) {
        //       overTime = app.time - app.timeLimit;
        //     } else {
        //       overTime = app.timeLimit - app.time;
        //     }
        //     app.points = (overTime.inMinutes * 0.2).round();
        //     if (app.points > 20) {
        //       app.points = 20;
        //     } else if (app.points < -20) {
        //       app.points = -20;
        //     }
        //   }
        //   });
        // }
        // eventTest3.forEach((element) {
        //   tempApps.forEach((App app) {
        //     if (element.packageName.contains(app.listName) && app.monitor) {
        //       var time = new Duration(
        //           milliseconds: int.parse(element.totalTimeInForeground));
        //       app.time = time;
        //       var overTime;
        //       if (app.timeLimit - app.time < Duration(minutes: 0)) {
        //         app.isBroken = true;
        //       }
        //       if (app.isBroken) {
        //         overTime = app.time - app.timeLimit;
        //       } else {
        //         overTime = app.timeLimit - app.time;
        //       }
        //       app.points = (overTime.inMinutes * 0.2).round();
        //       if (app.points > 20) {
        //         app.points = 20;
        //       } else if (app.points < -20) {
        //         app.points = -20;
        //       }
        //     }
        //   });
        // });
        tempApps.forEach((App app) {
          toStore.add(app.toJson());
        });
        tempApps = initialApps;
        storage.writeCounter(jsonEncode(toStore));
      });
      await refreshApps();
      loaded = true;
    }
  }

  double paddingCalc(index) {
    double padding = ((1 /
            ((_trackedApps[index].time.inMicroseconds / sum.inMicroseconds) *
                100)) *
        200);
    if (padding > 25) {
      padding = 25;
      return padding;
    } else {
      return padding;
    }
  }

  Icon getIconHome(App app) {
    switch (app.name) {
      case 'Facebook':
        return Icon(
          FontAwesomeIcons.facebook,
          color: Colors.white,
          size: 50,
          semanticLabel: 'Text to announce in accessibility modes',
        );
      case 'Instagram':
        return Icon(
          FontAwesomeIcons.instagram,
          color: Colors.white,
          size: 50,
          semanticLabel: 'Text to announce in accessibility modes',
        );
      case 'Reddit':
        return Icon(
          FontAwesomeIcons.reddit,
          color: Colors.white,
          size: 50,
          semanticLabel: 'Text to announce in accessibility modes',
        );
      case 'Snapchat':
        return Icon(
          FontAwesomeIcons.snapchat,
          color: Colors.black,
          size: 50,
          semanticLabel: 'Text to announce in accessibility modes',
        );
      case 'Tik Tok':
        return Icon(
          FontAwesomeIcons.tiktok,
          color: Colors.black,
          size: 50,
          semanticLabel: 'Text to announce in accessibility modes',
        );
      case 'Youtube':
        return Icon(
          FontAwesomeIcons.youtube,
          color: Colors.white,
          size: 50,
          semanticLabel: 'Text to announce in accessibility modes',
        );
    }
  }

  Color textColor(index) {
    if (_trackedApps[index].listName == "snapchat" ||
        _trackedApps[index].listName == "tiktok") {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  String timerWords(index) {
    String sentence;
    if (_trackedApps[index].time.inMinutes == 0) {
      sentence = "0 minutes";
    } else if (_trackedApps[index].time.inHours == 0 &&
        _trackedApps[index].time.inMinutes > 0) {
      sentence =
          (_trackedApps[index].time.inMinutes % 60).toString() + " minutes";
    } else if (_trackedApps[index].time.inHours > 0) {
      sentence = (_trackedApps[index].time.inHours).toString() +
          " hours " +
          (_trackedApps[index].time.inMinutes % 60).toString() +
          " minutes";
    }
    return sentence;
  }

  Widget generateGrid() {
    if (_trackedApps.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/images/etuLogo.png", height: 155)),
          RichText(
            text: TextSpan(
              text: 'Welcome to ',
              style: TextStyle(
                fontSize: 40,
                color: Color(0xFF083D77),
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'etu',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF083D77))),
                TextSpan(text: '!'),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Click on the ',
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: 'Settings',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' page to choose which apps to track!'),
              ],
            ),
          ),
        ],
      );
    } else {
      return GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          children: List.generate(_trackedApps.length, (index) {
            return GestureDetector(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(paddingCalc(index)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(int.parse(_trackedApps[index].color)),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getIconHome(_trackedApps[index]),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        timerWords(index),
                        style: TextStyle(
                          color: textColor(index),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded
          ? Center(
              child: generateGrid(),
            )
          : SizedBox.shrink(),
    );
  }
}
