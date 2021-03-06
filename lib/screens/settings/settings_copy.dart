import 'dart:convert';

import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:wellbeing_app/controllers/global.dart';
import 'package:wellbeing_app/controllers/settingsStorage.dart';
import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/apps.dart';
import 'package:wellbeing_app/models/settingsModel.dart';

class SettingsTest extends StatefulWidget {
  @override
  _SettingsTestState createState() => _SettingsTestState();
}

class _SettingsTestState extends State<SettingsTest> {
  final CounterStorage storage = CounterStorage();
  final SettingsStorage settingsStorage = SettingsStorage();
  var toStore = [];

  @override
  void initState() {
    // storage.readCounter();
    super.initState();
  }

  Future<Duration> initUsage(String name) async {
    UsageStats.grantUsagePermission();
    Duration usage = new Duration();
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate
          .subtract(new Duration(hours: endDate.hour, minutes: endDate.minute));
      List<AppUsageInfo> infos = await AppUsage.getAppUsage(startDate, endDate);
      setState(() {
        infos.where((element) {
          if (element.packageName == name) {
            usage = element.usage;
            return true;
          } else {
            return false;
          }
        });
      });
      return usage;
    } on AppUsageException catch (exception) {
      print(exception);
    }
    return usage;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Center(
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          DataTable(
            dividerThickness: 0.0,
            horizontalMargin: 0.0,
            columns: [
              DataColumn(
                label: Text('Applications'),
              ),
              DataColumn(
                label: Icon(FontAwesomeIcons.hourglass),
              ),
            ],
            rows: initialApps
                .map(
                  (index) => DataRow(
                    selected: index.monitor,
                    onSelectChanged: (bool value) {
                      setState(() {
                        index.monitor = value;
                      });
                      toStore = [];
                      index.timeLimit = index.timeLimit;
                      initialApps.forEach((app) {
                        if (app.name == index.name) {
                          app.monitor = index.monitor;
                        }
                        toStore.add(app.toJson());
                      });
                      storage.writeCounter(jsonEncode(toStore));
                    },
                    cells: [
                      DataCell(
                        Text(index.name),
                      ),
                      DataCell(
                        TextButton(
                          style: ButtonStyle(),
                          onPressed: () => onTap(index.id),
                          child: Text(
                            index.timeLimit
                                .toString()
                                .split('.')
                                .first
                                .padLeft(8, "0"),
                          ),
                        ),
                      )
                    ],
                  ),
                )
                .toList(),
          ),
          Divider(
            color: Color(0xFF78787d),
            height: 20,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Timer lock"),
                TextButton(
                  onPressed: null,
                  child: Text("5 days"),
                ),
              ],
            ),
          ),
          Divider(
            color: Color(0xFF78787d),
            height: 20,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Notifications"),
                Switch(
                  value: settings.notifications,
                  onChanged: (bool value) {
                    setState(() {
                      settings.notifications = value;
                    });
                    settingsStorage.writeCounter(jsonEncode(settings));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Consequence & Reward"),
                Switch(
                    value: settings.rewards,
                    onChanged: (bool value) {
                      setState(() {
                        settings.rewards = value;
                      });
                      settingsStorage.writeCounter(jsonEncode(settings));
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onTap(index) {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 5, suffix: Text(' hours')),
        const NumberPickerColumn(
            begin: 0, end: 55, suffix: Text(' minutes'), jump: 5),
      ]),
      delimiter: <PickerDelimiter>[
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      confirmText: 'OK',
      confirmTextStyle:
          TextStyle(inherit: false, color: Colors.red, fontSize: 22),
      title: Text('Select duration'),
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List<int> value) {
        // You get your duration here
        setState(() {
          initialApps[index].timeLimit = new Duration(
              hours: picker.getSelectedValues()[0],
              minutes: picker.getSelectedValues()[1]);
        });
      },
    ).showDialog(context);
  }
}
