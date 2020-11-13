import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:wellbeing_app/controllers/global.dart';
import 'package:flutter_picker/flutter_picker.dart';

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
              Text(apps[i]["name"]),
              TextButton(
                  onPressed: () => onTap(i),
                  child: Text(apps[i]["timeLimit"].toString()))
            ],
          ),
      ],
    )
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
