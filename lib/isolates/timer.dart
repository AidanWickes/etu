import 'dart:async';
import 'dart:isolate';
import 'dart:convert';

import 'package:isolate_handler/isolate_handler.dart';
import 'package:usage_stats/usage_stats.dart';

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
    Duration overTime = new Duration(seconds: 0);
    var currentApp;

    Timer.periodic(
      Duration(seconds: 10),
      (timer) async {
        var storage = new CounterStorage();
        List<App> apps = await storage.readCounter();
        UsageStats.grantUsagePermission();
        DateTime endDate = DateTime.now();
        DateTime startDate = endDate.subtract(new Duration(seconds: 10));
        // List<AppUsageInfo> infos =
        //     await AppUsage.getAppUsage(startDate, endDate);
        if (await UsageStats.checkUsagePermission()) {
          List<EventUsageInfo> events =
              await UsageStats.queryEvents(startDate, endDate);
          // print(timer.tick);
          // print(events.reversed.toList());
          events.forEach((element) {
            apps.forEach((app) {
              if (element.eventType == '1' &&
                  element.packageName.contains(app.listName) &&
                  app.monitor) {
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
                  currentApp == app.name &&
                  app.monitor) {
                // app.sessions.add(sessionTime);
                inSession = false;
                currentApp = '';
              }
            });
          });
        }
        if (inSession == true) {
          await apps.forEach((app) {
            if (app.name == currentApp) {
              app.time += Duration(seconds: 10);
              print(app.time - app.timeLimit);
              print(app.time);
              print(app.timeLimit);
              if (app.timeLimit - app.time < Duration(minutes: 5) &&
                  app.notifications == 4) {
                var message = "5 minutes left on " + currentApp;
                app.timeLimit.toString();
                notificationPlugin.showNotification(message);
                app.notifications--;
              }
              if (app.time > app.timeLimit) {
                if (app.notifications == 3) {
                  var message = "Reached " + currentApp + " time limit.";
                  notificationPlugin.showNotification(message);
                  app.notifications--;
                } else if (app.time - app.timeLimit > Duration(minutes: 5) &&
                    app.notifications == 2) {
                  var message = "5 minutes over on " + currentApp;
                  notificationPlugin.showNotification(message);
                  app.notifications--;
                } else if (app.time - app.timeLimit > Duration(minutes: 10) &&
                    app.notifications == 1) {
                  var message = "10 minutes over on" + currentApp;
                  notificationPlugin.showNotification(message);
                  app.notifications--;
                }
                app.isBroken = true;
                overTime = app.time - app.timeLimit;
                app.points = (overTime.inMinutes * 0.2).round();
                // print(app.points);
                // print(overTime.inMinutes * 0.2);
              } else {
                overTime = app.timeLimit - app.time;
                app.points = (overTime.inMinutes * 0.2).round();
                // print(app.points);
              }
            }
          });
          var toStore = [];
          apps.forEach((app) => {toStore.add(app.toJson())});
          await storage.writeCounter(jsonEncode(toStore));
          sessionTime += Duration(seconds: 10);
        }
      },
    );
  }
}
