import 'package:flutter/material.dart';
import 'package:wellbeing_app/controllers/donut_chart.dart';
import 'package:wellbeing_app/models/apps.dart';

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
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
                initialApps[index].isExpanded = !isExpanded;
              });
            },
            children: initialApps.map((App app) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(app.name),
                  );
                },
                body: Column(
                  children: [
                    ListTile(
                      title: Text('Total Time'),
                      trailing: Text(app.time.toString()),
                    ),
                    ListTile(
                      title: Text('Sessions'),
                      trailing: Text(app.sessions.length.toString()),
                    )
                  ],
                ),
                isExpanded: app.isExpanded,
              );
            }).toList(),
          )
        ],
      )),
    );
  }
}
