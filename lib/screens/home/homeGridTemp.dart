import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:app_usage/app_usage.dart';

import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/apps.dart';

Duration sum;
List<App> _trackedApps;

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
        child: Stack(
          children: [for (var i = 0; i < _trackedApps.length; i++) getBox(i)],
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

  if (_trackedApps[i].time.inMicroseconds > 0) {
    return FractionallySizedBox(
      heightFactor: widthPerc,
      widthFactor: widthPerc,
      child: FlatButton(
        child: Text(_trackedApps[i].name),
        color: Color(int.parse(_trackedApps[i].color)),
        onPressed: () {},
      ),
    );
  } else {
    return SizedBox.shrink();
  }
}
