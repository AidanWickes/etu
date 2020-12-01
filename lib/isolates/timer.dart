import 'dart:async';
import 'dart:isolate';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:wellbeing_app/controllers/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:wellbeing_app/controllers/global.dart' as oldApps;
import 'package:isolate_handler/isolate_handler.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/apps.dart';
import 'package:wellbeing_app/notifications/notification.dart';

var sessions = [];

class CountdownTimer {
  final receivePort = ReceivePort();
  // HandledIsolate _isolate;
  final _isolates = IsolateHandler();
  var storage = new CounterStorage();
  List<EventUsageInfo> events = [];

  void stop() {
    receivePort.close();
    // _isolate.kill(priority: Isolate.immediate);
    // _isolate.dispose();
  }

  Future<void> start() async {
    // getStorage();
    _isolates.spawn(_entryPoint);
    receivePort.sendPort.send('');
  }

  static void _entryPoint(Map map) {
    var inSession = false;
    Duration sessionTime = new Duration(seconds: 0);
    Duration currentTime = new Duration(seconds: 0);
    var currentApp;

    Timer.periodic(
      Duration(seconds: 10),
      (timer) async {
        var storage = new CounterStorage();
        List<App> apps = await storage.readCounter();

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
                element.packageName.contains(app.listName)) {
              print(app.name.toString() + " session started");
              currentApp = app.name;
              if (inSession == false) {
                inSession = true;
                sessionTime = new Duration(seconds: 0);
                if (app.time.toString() != '0') {
                  return currentTime = app.time;
                } else {
                  return currentTime = new Duration(seconds: 0);
                }
              }
            } else if (element.eventType != '1' &&
                element.packageName.contains(app.listName) &&
                inSession &&
                currentApp == app.name) {
              app.sessions.add(sessionTime);
              inSession = false;
              currentApp = '';
            }
          });
        });
        if (inSession == true) {
          await apps.forEach((app) {
            if (app.name == currentApp) {
              print(app.time);
              app.time += Duration(seconds: 10);
              print(app.time);
              if (app.time > app.timeLimit) {
                var message = "App: " +
                    currentApp +
                    " Time:  " +
                    app.time.toString() +
                    " Limit " +
                    app.timeLimit.toString();
                notificationPlugin.showNotification(message);
              }
            }
            // app["timeLimit"] = app["timeLimit"].toString();
            // app["time"] = app["time"].toString();
          });
          var toStore = [];
          apps.forEach((app) => {toStore.add(app.toJson())});
          await storage.writeCounter(jsonEncode(toStore));
          sessionTime += Duration(seconds: 10);
        }
        // event type 1 is opened and 2 is closed
        // }
      },
    );
  }
}
