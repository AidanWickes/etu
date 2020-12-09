import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wellbeing_app/controllers/donut_chart.dart';
import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/apps.dart';

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  final CounterStorage storage = CounterStorage();
  List<App> _trackedApps;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    storage.readCounter();
    _trackedApps = initialApps.where((i) => i.monitor).toList();
    return Scaffold(
      body: Container(
          child: new ListView(
        children: [
          new SizedBox(
            height: 300,
            child: DonutPieChart.withSampleData(),
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
                            Text(_trackedApps[index].name),
                            Text(_trackedApps[index].time.toString())
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
                      title: Text('Timer Status'),
                      trailing: _trackedApps[index].isBroken
                          ? Text('true')
                          : Text('False'),
                    ),
                    ListTile(
                      title: Text('Total Time'),
                      trailing: Text(_trackedApps[index].time.toString()),
                    ),
                    ListTile(
                      title: Text('Sessions'),
                      trailing:
                          Text(_trackedApps[index].sessions.length.toString()),
                    ),
                    ListTile(
                      title: Text('Consequence'),
                      trailing: _trackedApps[index].isBroken
                          ? Text('-' + _trackedApps[index].points.toString())
                          : Text('+' + _trackedApps[index].points.toString()),
                    ),
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
