class App {
  int id;
  String name;
  bool monitor;
  String listName;
  int time;
  Duration timeLimit;

  App(
      {this.id,
      this.name,
      this.monitor,
      this.listName,
      this.time,
      this.timeLimit});

  App.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    monitor = json['monitor'];
    listName = json['listName'];
    time = json['time'];
    timeLimit = json['timeLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['monitor'] = this.monitor;
    data['listName'] = this.listName;
    data['time'] = this.time;
    data['timeLimit'] = this.timeLimit;
    return data;
  }
}

List<App> initialApps = []
  ..add(App(
      id: 0,
      name: "Facebook",
      monitor: false,
      listName: "facebook",
      time: 0,
      timeLimit: Duration(hours: 2, minutes: 0)))
  ..add(App(
      id: 1,
      name: "Instagram",
      monitor: false,
      listName: "instagram",
      time: 0,
      timeLimit: Duration(hours: 2, minutes: 5)))
  ..add(App(
      id: 2,
      name: "Reddit",
      monitor: false,
      listName: "reddit",
      time: 0,
      timeLimit: Duration(hours: 2, minutes: 10)))
  ..add(App(
      id: 3,
      name: "Snapchat",
      monitor: false,
      listName: "snapchat",
      time: 0,
      timeLimit: Duration(hours: 2, minutes: 15)))
  ..add(App(
      id: 4,
      name: "Tik Tok",
      monitor: false,
      listName: "tiktok",
      time: 0,
      timeLimit: Duration(hours: 2, minutes: 20)))
  ..add(App(
      id: 5,
      name: "Youtube",
      monitor: false,
      listName: "youtube",
      time: 0,
      timeLimit: Duration(hours: 2, minutes: 25)));
