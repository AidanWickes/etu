import 'dart:async';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:wellbeing_app/controllers/global.dart';
import 'package:isolate_handler/isolate_handler.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wellbeing_app/notifications/notification.dart';

class CountdownTimer {
  final receivePort = ReceivePort();
  // HandledIsolate _isolate;
  final _isolates = IsolateHandler();
  List<EventUsageInfo> events = [];

  void stop() {
    receivePort.close();
    // _isolate.kill(priority: Isolate.immediate);
    // _isolate.dispose();
  }

  Future<void> start() async {
    _isolates.spawn(_entryPoint);
    receivePort.sendPort.send('');
  }

  static void _entryPoint(Map map) {
    var inSession = false;
    Duration sessionTime = new Duration(seconds: 0);
    var currentApp;

    Timer.periodic(
      Duration(seconds: 10),
      (timer) async {
        // if (timer.tick == initialTime) {
        //   timer.cancel();
        //   port.send(timer.tick);
        //   port.send('Timer finished');
        // } else {
        DateTime endDate = DateTime.now();
        DateTime startDate = endDate.subtract(new Duration(seconds: 10));
        // List<AppUsageInfo> infos =
        //     await AppUsage.getAppUsage(startDate, endDate);
        List<EventUsageInfo> events =
            await UsageStats.queryEvents(startDate, endDate);
        // print(timer.tick);
        // print(events.reversed.toList());
        events.forEach((element) {
          apps.forEach((app) {
            if (element.eventType == '1' &&
                element.packageName.contains(app["listName"])) {
              print(app["name"].toString() + " session started");
              currentApp = app["name"];
              if (inSession == false) {
                inSession = true;
                sessionTime = new Duration(seconds: 0);
              }
            } else if (element.eventType == '2' &&
                element.packageName.contains(app["listName"])) {
              inSession = false;
              currentApp = '';
            }
          });
        });
        if (inSession == true) {
          sessionTime += Duration(seconds: 10);
          var message = currentApp +
              " on " +
              sessionTime.toString() +
              "? You've got a problem mate";
          notificationPlugin.showNotification(message);
          print(sessionTime);
        }
        // event type 1 is opened and 2 is closed
        // }
      },
    );
  }
}
