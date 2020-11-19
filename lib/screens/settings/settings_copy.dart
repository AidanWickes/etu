import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:wellbeing_app/models/apps.dart';

class SettingsCopy extends StatefulWidget {
  @override
  _SettingsCopyState createState() => _SettingsCopyState();
}

class _SettingsCopyState extends State<SettingsCopy> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: initialApps.map((currentObject) {
          return Container(
            child: Row(
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      currentObject.monitor = value;
                    });
                    currentObject.timeLimit = currentObject.timeLimit;
                  },
                  value: currentObject.monitor,
                  activeColor: Color(0xFF6200EE),
                ),
                Expanded(child: Text(currentObject.name)),
                TextButton(
                    onPressed: () => onTap(currentObject.id),
                    child: Text(currentObject.timeLimit
                        .toString()
                        .split('.')
                        .first
                        .padLeft(8, "0"))),
              ],
            ),
          );
        }).toList(),
      ),
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
          initialApps[index].timeLimit = new Duration(
              hours: picker.getSelectedValues()[0],
              minutes: picker.getSelectedValues()[1]);
        });
      },
    ).showDialog(context);
  }
}
