import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:app_usage/app_usage.dart';

import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/apps.dart';

class HomeGrid extends StatefulWidget {
  @override
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  List<EventUsageInfo> events = [];
  List<AppUsageInfo> _infos = [];

  var storage = new CounterStorage();

  List<App> _trackedApps;

  @override
  void initState() {
    _trackedApps = initialApps.where((i) => i.monitor).toList();
    initUsage();
    super.initState();
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
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate widgets that display their index in the List.
        children: List.generate(_trackedApps.length, (index) {
          return Center(
            child: Text(
              _trackedApps[index].name,
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        }),
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
