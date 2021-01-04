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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              child: GridView.count(
                //physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(_trackedApps.length, (index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(paddingCalc(index)),
                      child: Card(
                        color: Color(int.parse(_trackedApps[index].color)),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              getIconHome(_trackedApps[index]),
                              Text(
                                _trackedApps[index].name,
                                style: TextStyle(
                                  color: textColor(index),
                                ),
                              ),
                              Text(
                                (_trackedApps[index].time.inHours).toString() +
                                    "hrs " +
                                    (_trackedApps[index].time.inMinutes % 60)
                                        .toString() +
                                    "mins " +
                                    (_trackedApps[index].time.inSeconds % 60)
                                        .toString() +
                                    "s ",
                                style: TextStyle(
                                  color: textColor(index),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
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
