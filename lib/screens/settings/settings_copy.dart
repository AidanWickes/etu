import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/apps.dart';

class SettingsCopy extends StatefulWidget {
  @override
  _SettingsCopyState createState() => _SettingsCopyState();
}

class _SettingsCopyState extends State<SettingsCopy> {
  final CounterStorage storage = CounterStorage();

  var toStore = [];

  @override
  void initState() {
    storage.readCounter();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Column(
        children: initialApps.map((currentObject) {
          return Container(
            child: Row(
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      currentObject.monitor = value;
                    });
                    toStore = [];
                    currentObject.timeLimit = currentObject.timeLimit;
                    initialApps.forEach((app) {
                      if (app.name == currentObject.name) {
                        app.monitor = currentObject.monitor;
                      }
                      toStore.add(app.toJson());
                    });
                    storage.writeCounter(jsonEncode(toStore));
                    // storage.readCounter();
                  },
                  value: currentObject.monitor,
                  activeColor: Color(0xFF6200EE),
                ),
                Expanded(child: Text(currentObject.name)),
                TextButton(
                    onPressed: () => onTap(currentObject.id),
                    child: Text(currentObject.timeLimit
                        .toString()
                        .split('.')
                        .first
                        .padLeft(8, "0"))),
              ],
            ),
          );
        }).toList(),
      ),
      Divider(
        color: Colors.black,
        height: 20,
        thickness: 1,
        indent: 0,
        endIndent: 0,
      ),
      //TextButton(onPressed: () => SettingsTest(), child: Text("New Settings")),
      Row(
        children: [
          Expanded(child: Text("Timer lock")),
          TextButton(onPressed: null, child: Text("5 days")),
        ],
      ),
      Divider(
        color: Colors.black,
        height: 20,
        thickness: 1,
        indent: 0,
        endIndent: 0,
      ),
      Row(
        children: [
          Expanded(child: Text("Notifications")),
          Switch(value: null, onChanged: null)
        ],
      ),
      Row(
        children: [
          Expanded(child: Text("Consequence & Reward")),
          Switch(value: null, onChanged: null)
        ],
      ),
    ]));
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
