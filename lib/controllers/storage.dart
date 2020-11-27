import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:wellbeing_app/controllers/global.dart';
import 'package:wellbeing_app/models/apps.dart';

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

      // var fromJson = App.fromJson(test);
      var convList = [];
      //   apps = test;
      var i = 0;
      test.forEach((element) {
        convList.add(App.fromJson(element));
        apps[i] = element;
        i++;
      });
      return apps;
    } catch (e) {
      // If encountering an error, return 0
      return ['Error'];
    }
  }

  Future<File> writeCounter(counter) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$counter');
  }
}
