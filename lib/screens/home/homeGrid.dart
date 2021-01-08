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

  List<App> _trackedApps;
  List<App> _orderedApps;
  List sizePerc = [0.0, 2.0, 4.0, 6.0, 8.0, 10.0, 12.0];

  @override
  void initState() {
    _trackedApps = initialApps.where((i) => i.monitor == true).toList();
    initUsage();
    super.initState();

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
  }

  Future<void> initUsage() async {
    UsageStats.grantUsagePermission();
    if (await UsageStats.checkUsagePermission()) {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate
          .subtract(new Duration(hours: endDate.hour, minutes: endDate.minute));
      List<AppUsageInfo> infos = await AppUsage.getAppUsage(startDate, endDate);
      setState(() {
        _infos.clear();
        infos.forEach((element) {
          initialApps.forEach((appElement) {
            if (element.packageName == appElement.listName &&
                appElement.monitor) {
              var toStore = [];
              initialApps.forEach((app) {
                if (app.name == appElement.name) {
                  app.time = element.usage;
                }
                toStore.add(app.toJson());
              });
              storage.writeCounter(jsonEncode(toStore));
              return _infos.add(element);
            } else if (appElement.listName == "youtube") {
              if (element.appName == appElement.listName &&
                  appElement.monitor) {
                var toStore = [];
                initialApps.forEach((app) {
                  if (app.name == appElement.name) {
                    app.time = element.usage;
                  }
                  toStore.add(app.toJson());
                });
                storage.writeCounter(jsonEncode(toStore));
                return _infos.add(element);
              }
            }
          });
        });
      });
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
          RichText(
            text: TextSpan(
              text: 'Welcome to ',
              style: TextStyle(
                fontSize: 50,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'etu', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.6),
                  //     spreadRadius: 2,
                  //     blurRadius: 9,
                  //     offset: Offset(3, 7), // changes position of shadow
                  //   ),
                  // ],
                ),
                //color: Color(int.parse(_trackedApps[index].color)),
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
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: generateGrid(),
      ),
    );
  }
}
