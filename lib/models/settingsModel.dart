import 'apps.dart';

class Settings {
  DateTime lastLaunched;
  int totalPoints;
  bool notifications;
  bool rewards;
  List<App> history;
  Settings(
      {this.lastLaunched, this.totalPoints, this.notifications, this.rewards});

  Settings.fromJson(Map<String, dynamic> json) {
    lastLaunched = DateTime.parse(json['lastLaunched'].toString());
    totalPoints = json['totalPoints'];
    notifications = json['notifications'];
    rewards = json['rewards'];
    if (json['history'].toString() == "null" ||
        json['history'].toString() == '[]') {
      history = [];
    } else {
      List<App> convertedApps = [];
      json['history'].forEach((element) {
        convertedApps.add(App.fromJson((element)));
      });
      history = convertedApps;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastLaunched'] = lastLaunched.toString();
    data['totalPoints'] = totalPoints;
    data['notifications'] = notifications;
    data['rewards'] = rewards;
    var convertedApps = [];
    history.forEach((element) {
      convertedApps.add(element.toJson());
    });
    data['history'] = convertedApps;
    return data;
  }
}

Settings settings = new Settings(
    lastLaunched: DateTime.now(),
    totalPoints: 0,
    notifications: true,
    rewards: true);
