class Apps {
  int id;
  String name;
  bool monitor;
  String listName;
  int time;
  Duration timeLimit;

  Apps(
      {this.id,
      this.name,
      this.monitor,
      this.listName,
      this.time,
      this.timeLimit});

  Apps.fromJson(Map<String, dynamic> json) {
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

List<Apps> trackedApps = []
  ..add(Apps(
      id: 0,
      name: "Instagram",
      monitor: false,
      listName: "instagram",
      time: 0,
      timeLimit: Duration(hours: 2, minutes: 5)))
  ..add(Apps(
      id: 1,
      name: "Snapchat",
      monitor: false,
      listName: "snapchat",
      time: 0,
      timeLimit: Duration(hours: 2, minutes: 10)))
  ..add(Apps(
      id: 2,
      name: "Youtube",
      monitor: false,
      listName: "youtube",
      time: 0,
      timeLimit: Duration(hours: 2, minutes: 15)));
