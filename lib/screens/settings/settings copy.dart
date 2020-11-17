import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:wellbeing_app/controllers/global.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:wellbeing_app/models/apps.dart';

final CounterStorage storage = CounterStorage();

class SettingsTest extends StatefulWidget {
  @override
  _SettingsTestState createState() => _SettingsTestState();
}

class _SettingsTestState extends State<SettingsTest> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: trackedApps.map((currentObject) {
          return Container(
            child: Row(
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      currentObject.monitor = value;
                    });
                    currentObject.timeLimit = currentObject.timeLimit;
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
          trackedApps[index].timeLimit = new Duration(
              hours: picker.getSelectedValues()[0],
              minutes: picker.getSelectedValues()[1]);
        });
      },
    ).showDialog(context);
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/apps.json');
  }

  Future<List> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      var test = jsonDecode(contents);

      //   apps = test;
      var i = 0;
      test.forEach((element) {
        apps[i] = element;
        i++;
      });
      return test;
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  Future<File> writeCounter(counter) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$counter');
  }
}
