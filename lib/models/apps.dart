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