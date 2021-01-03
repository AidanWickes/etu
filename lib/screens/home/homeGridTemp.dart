import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:app_usage/app_usage.dart';

import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/apps.dart';

List<App> _trackedApps;
Duration sum;
var hours;
var minutes;
var seconds;

class HomeGridTemp extends StatefulWidget {
  @override
  _HomeGridTempState createState() => _HomeGridTempState();
}

class _HomeGridTempState extends State<HomeGridTemp> {
  List<EventUsageInfo> events = [];
  List<AppUsageInfo> _infos = [];

  var storage = new CounterStorage();

  @override
  void initState() {
    _trackedApps = initialApps.where((i) => i.monitor).toList();
    initUsage();
    super.initState();

    sum = Duration(hours: 0, minutes: 0);
    for (var ii = 0; ii < _trackedApps.length; ii++) {
      sum = sum + _trackedApps[ii].time;
    }

    _trackedApps.sort((b, a) => a.time.compareTo(b.time));

    hours = sum.inHours;
    minutes = sum.inMinutes % 60;
    seconds = sum.inSeconds % 60;
  }

  Future<void> initUsage() async {
    UsageStats.grantUsagePermission();
    try {
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
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  "Hello",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: 'Total Time Today: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                        text: hours.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'hrs '),
                      TextSpan(
                        text: minutes.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'mins'),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  for (var i = 0; i < _trackedApps.length; i++) getBox(i)
                ],
              ),
            ),
          ],
        ),
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
    );
  }
}

Widget getBox(i) {
  var iterable = (i + 1);
  var widthPerc = 1 / iterable;
  var alignment;

  switch (iterable % 2) {
    case 0:
      {
        alignment = Alignment.bottomLeft;
      }
      break;

    case 1:
      {
        alignment = Alignment.bottomRight;
      }
      break;
  }

  if (_trackedApps[i].time.inMicroseconds > 0) {
    return Align(
      alignment: alignment,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: FractionallySizedBox(
          heightFactor: widthPerc,
          widthFactor: widthPerc,
          child: Positioned(
            top: 50,
            left: 50,
            child: FlatButton(
              child: Column(
                children: [
                  getIcon(_trackedApps[i]),
                  Text(_trackedApps[i].name),
                  Text((_trackedApps[i].time.inHours).toString() +
                      "hrs " +
                      (_trackedApps[i].time.inMinutes % 60).toString() +
                      "mins " +
                      (_trackedApps[i].time.inSeconds % 60).toString() +
                      "s ")
                ],
              ),
              color: Color(int.parse(_trackedApps[i].color)),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  } else {
    return SizedBox.shrink();
  }
}
