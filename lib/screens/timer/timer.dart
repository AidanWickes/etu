import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wellbeing_app/controllers/donut_chart.dart';
import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/apps.dart';
import 'package:wellbeing_app/models/settingsModel.dart';

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  final CounterStorage storage = CounterStorage();
  List<App> _trackedApps;
  int opens;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    opens = 0;
    _trackedApps = initialApps.where((app) {
      var overTime;
      if (app.isBroken) {
        overTime = app.time - app.timeLimit;
      } else {
        overTime = app.timeLimit - app.time;
      }
      opens += app.sessions.length;
      app.points = (overTime.inMinutes * 0.2).round();
      if (app.points > 20) {
        app.points = 20;
      } else if (app.points < -20) {
        app.points = -20;
      }
      return app.monitor;
    }).toList();
    return Scaffold(
      body: Container(
          child: new ListView(
        children: [
          new SizedBox(
            height: 300,
            child: DonutPieChart.withSampleData(),
          ),
          Column(
            children: [
              Text('Total Opens',
                  style: TextStyle(fontSize: 20, color: Color(0xFF083D77))),
              Text(
                opens.toString(),
                style: TextStyle(fontSize: 35),
              )
            ],
          ),
          Divider(
            color: Colors.white,
            height: 10,
            indent: 0,
            endIndent: 0,
          ),
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _trackedApps[index].isExpanded = !isExpanded;
                // initialApps[index].isExpanded = !isExpanded;
              });
            },
            children: List.generate(_trackedApps.length, (index) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Row(children: [
                      Column(
                        children: [
                          getIcon(_trackedApps[index]),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(_trackedApps[index].name,
                                style: TextStyle(color: Color(0xFF083D77))),
                            Text(
                                _trackedApps[index]
                                    .time
                                    .toString()
                                    .split('.')
                                    .first
                                    .padLeft(8, "0"),
                                style: TextStyle(color: Color(0xFF083D77))),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      )
                    ]),
                  );
                },
                body: Column(
                  children: [
                    ListTile(
                      title: Text('Timer Status',
                          style: TextStyle(color: Color(0xFF083D77))),
                      trailing: _trackedApps[index].isBroken
                          ? Icon(
                              FontAwesomeIcons.hourglassEnd,
                              size: 24.0,
                              color: Color(0xFF78787D),
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            )
                          : Icon(
                              FontAwesomeIcons.hourglassHalf,
                              size: 24.0,
                              color: Color(0xFF083D77),
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                    ),
                    // ListTile(
                    //   title: Text('Total Time'),
                    //   trailing: Text(_trackedApps[index].time.toString()),
                    // ),
                    ListTile(
                      title: Text('Times Launched',
                          style: TextStyle(color: Color(0xFF083D77))),
                      trailing: Text(
                          _trackedApps[index].sessions.length.toString(),
                          style: TextStyle(color: Color(0xFF083D77))),
                    ),
                    settings.rewards
                        ? ListTile(
                            title: _trackedApps[index].isBroken
                                ? Text('Consequence',
                                    style: TextStyle(color: Color(0xFF083D77)))
                                : Text('Reward',
                                    style: TextStyle(color: Color(0xFF083D77))),
                            trailing: _trackedApps[index].isBroken
                                ? Text(
                                    '-' + _trackedApps[index].points.toString(),
                                    style: TextStyle(color: Color(0xFF083D77)))
                                : Text(
                                    '+' + _trackedApps[index].points.toString(),
                                    style: TextStyle(color: Color(0xFF083D77))),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                isExpanded: _trackedApps[index].isExpanded,
              );
            }).toList(),
          )
        ],
      )),
    );
  }
}
