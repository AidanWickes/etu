class App {
  int id;
  String name;
  bool monitor;
  String listName;
  Duration time;
  Duration timeLimit;
  List<Duration> sessions;
  bool isExpanded;
  String color;

  App(
      {this.id,
      this.name,
      this.monitor,
      this.listName,
      this.time,
      this.timeLimit,
      this.sessions,
      this.isExpanded,
      this.color});

  App.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    monitor = json['monitor'];
    listName = json['listName'];
    time = getTime(json['time']);
    timeLimit = getTime(json['timeLimit']);
    if (json['sessions'].toString() == "null" ||
        json['sessions'].toString() == '[]') {
      sessions = [];
    } else {
      List<Duration> convertedTimes = [];
      json['sessions'].forEach((element) {
        convertedTimes.add(getTime(element));
      });
      sessions = convertedTimes;
    }
    isExpanded = json['isExpanded'];
    color = json['color'];
  }

  Duration getTime(String timeLimit) {
    int hours = 0;
    int minutes = 0;
    int micros;
    if (timeLimit.toString() != "null") {
      List<String> parts = timeLimit.split(':');
      if (parts.length > 2) {
        hours = int.parse(parts[parts.length - 3]);
      }
      if (parts.length > 1) {
        minutes = int.parse(parts[parts.length - 2]);
      }
      micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    }
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['monitor'] = monitor;
    data['listName'] = listName;
    data['time'] = time.toString();
    data['timeLimit'] = timeLimit.toString();
    var convertedSession = [];
    sessions.forEach((element) {
      convertedSession.add(element.toString());
    });
    data['sessions'] = convertedSession;
    data['isExpanded'] = isExpanded;
    data['color'] = color;
    return data;
  }
}

List<App> initialApps = []
  ..add(App(
      id: 0,
      name: "Facebook",
      monitor: false,
      listName: "facebook",
      time: Duration(hours: 0, minutes: 0),
      timeLimit: Duration(hours: 2, minutes: 0),
      sessions: [],
      isExpanded: false,
      color: '#4267b2'))
  ..add(App(
      id: 1,
      name: "Instagram",
      monitor: false,
      listName: "instagram",
      time: Duration(hours: 0, minutes: 0),
      timeLimit: Duration(hours: 2, minutes: 5),
      sessions: [Duration(minutes: 20), Duration(minutes: 10)],
      isExpanded: false,
      color: '#c13584'))
  ..add(App(
      id: 2,
      name: "Reddit",
      monitor: false,
      listName: "reddit",
      time: Duration(hours: 0, minutes: 0),
      timeLimit: Duration(hours: 2, minutes: 10),
      sessions: [],
      isExpanded: false,
      color: '#c8c8c8'))
  ..add(App(
      id: 3,
      name: "Snapchat",
      monitor: false,
      listName: "snapchat",
      time: Duration(hours: 0, minutes: 0),
      timeLimit: Duration(hours: 2, minutes: 15),
      sessions: [Duration(hours: 1, minutes: 20)],
      isExpanded: false,
      color: '#fffc00'))
  ..add(App(
      id: 4,
      name: "Tik Tok",
      monitor: false,
      listName: "tiktok",
      time: Duration(hours: 0, minutes: 0),
      timeLimit: Duration(hours: 2, minutes: 20),
      sessions: [],
      isExpanded: false,
      color: '#c8c8c8'))
  ..add(App(
      id: 5,
      name: "Youtube",
      monitor: false,
      listName: "youtube",
      time: Duration(hours: 0, minutes: 0),
      timeLimit: Duration(hours: 2, minutes: 25),
      sessions: [],
      isExpanded: false,
      color: '#ff0000'));
