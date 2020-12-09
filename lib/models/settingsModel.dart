class Settings {
  DateTime lastLaunched;
  int totalPoints;
  bool notifications;
  bool rewards;
  Settings(
      {this.lastLaunched, this.totalPoints, this.notifications, this.rewards});

  Settings.fromJson(Map<String, dynamic> json) {
    lastLaunched = DateTime.parse(json['lastLaunched'].toString());
    totalPoints = json['totalPoints'];
    notifications = json['notifications'];
    rewards = json['rewards'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastLaunched'] = lastLaunched.toString();
    data['totalPoints'] = totalPoints;
    data['notifications'] = notifications;
    data['rewards'] = rewards;
    return data;
  }
}

Settings settings = new Settings(
    lastLaunched: DateTime.now(),
    totalPoints: 0,
    notifications: true,
    rewards: true);
