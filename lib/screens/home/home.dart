import 'package:flutter/material.dart';
import 'dart:async';
import 'package:usage_stats/usage_stats.dart';
import 'package:app_usage/app_usage.dart';
import 'package:wellbeing_app/controllers/global.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<EventUsageInfo> events = [];
  List<AppUsageInfo> _infos = [];

  @override
  void initState() {
    initUsage();
    super.initState();
  }

  Future<void> initUsage() async {
    // UsageStats.grantUsagePermission();
    // DateTime endDate = new DateTime.now();
    // DateTime startDate = endDate.subtract(new Duration(days: 1));
    // List<EventUsageInfo> queryEvents =
    // await UsageStats.queryEvents(startDate, endDate);
    //
    // this.setState(() {
    //   events = queryEvents.reversed.toList();
    // });

    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(new Duration(days: 1));
      List<AppUsageInfo> infos = await AppUsage.getAppUsage(startDate, endDate);
      setState(() {
        _infos.clear();
        infos.forEach((element) {
          apps.forEach((appElement) {
            if (element.packageName == appElement["listName"] && appElement["monitor"]){
              appElement["time"] =  element.usage.toString();
              return _infos.add(element);
            } else if (appElement["listName"] == "youtube"){
              if (element.appName == appElement["listName"] && appElement["monitor"]){
                appElement["time"] = element.usage.toString();
                return _infos.add(element);
              }
            }
          });
          // if (element.packageName == "google" && element.appName == "youtube" || element.packageName == "instagram" || element.packageName == "snapchat"){
          //   return _infos.add(element);
          // }
        });
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            if (apps[index]["monitor"]){
              return ListTile(
                  title: Text(apps[index]["name"]),
                  trailing: Text(apps[index]["time"].toString()));
            } else {
              return SizedBox.shrink();
            }
          }),
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
