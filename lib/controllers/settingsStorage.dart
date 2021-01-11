import 'package:path_provider/path_provider.dart';
import 'package:wellbeing_app/controllers/storage.dart';
import 'package:wellbeing_app/models/apps.dart';
import 'dart:io';
import 'dart:convert';
import 'package:wellbeing_app/models/settingsModel.dart';

class SettingsStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/settings.json');
  }

  Future<Settings> readSettings() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      var test = jsonDecode(contents);

      var fromJson = Settings.fromJson(test);
      if (fromJson.lastLaunched.day != DateTime.now().day) {
        fromJson.lastLaunched = DateTime.now();
        fromJson.lock--;
        if (fromJson.lock <= 0) {
          fromJson.lock = 0;
          fromJson.isLocked = false;
        } else {
          fromJson.isLocked = true;
        }
        await writeCounter(jsonEncode(fromJson));
        fromJson.history = await CounterStorage().readCounter();
        initialApps.forEach((App app) {
          if (app.isBroken) {
            fromJson.totalPoints -= app.points;
          } else {
            fromJson.totalPoints += app.points;
          }
        });
        await writeCounter(jsonEncode(fromJson));
        var toStore = [];
        initialApps.forEach((app) {
          if (fromJson.lock == 0) {
            app.locked = false;
          }
          app.points = 0;
          app.isBroken = false;
          app.notifications = 4;
          toStore.add(app.toJson());
        });
        // initUsage();
        CounterStorage().writeCounter(jsonEncode(toStore));
      }

      // var fromJson = App.fromJson(test);
      //   apps = test;
      settings = fromJson;
      return fromJson;
    } catch (e) {
      // If encountering an error, return 0
      print(e);
    }
  }

  Future<File> writeCounter(counter) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$counter');
  }
}
