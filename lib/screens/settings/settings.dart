import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:wellbeing_app/controllers/global.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:wellbeing_app/controllers/storage.dart';
//import 'package:wellbeing_app/screens/settings/settings%20copy.dart';

final CounterStorage storage = CounterStorage();

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Row(
          children: [
            Text('Applications'),
            Icon(FontAwesomeIcons.hourglass),
          ],
        ),
        for (var i = 0; i < apps.length; i += 1)
          Row(
            children: [
              Checkbox(
                onChanged: (bool value) {
                  setState(() {
                    apps[i]["monitor"] = value;
                  });
                  apps[i]["timeLimit"] = apps[i]["timeLimit"].toString();
                  storage.writeCounter(jsonEncode(apps));
                },
                value: apps[i]["monitor"],
                activeColor: Color(0xFF6200EE),
              ),
              Expanded(child: Text(apps[i]["name"])),
              TextButton(
                  onPressed: () => onTap(i),
                  child: Text(apps[i]["timeLimit"]
                      .toString()
                      .split('.')
                      .first
                      .padLeft(8, "0"))),
            ],
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
      ],
    ));
  }

  void onTap(index) {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 5, suffix: Text(' hours')),
        const NumberPickerColumn(
            begin: 0, end: 55, suffix: Text('minutes'), jump: 5),
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
          apps[index]["timeLimit"] = Duration(
                  hours: picker.getSelectedValues()[0],
                  minutes: picker.getSelectedValues()[1])
              .toString();
        });

        storage.writeCounter(jsonEncode(apps));
      },
    ).showDialog(context);
  }
}
