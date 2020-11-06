import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:wellbeing_app/controllers/global.dart';

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
      body: ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(apps[index]["name"]),
                trailing: Switch(
                  value: apps[index]["monitor"],
                  onChanged: (value) {
                  setState(() {
                    apps[index]["monitor"] = value;
                  }
                );
                storage.writeCounter(jsonEncode(apps));
                },
              )
            );
          }
      ),
    );
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