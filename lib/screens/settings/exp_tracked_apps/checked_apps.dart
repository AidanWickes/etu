import 'package:flutter/material.dart';
import 'package:wellbeing_app/models/apps.dart';

class AppCheck extends StatefulWidget {
  final App app;
  AppCheck(this.app);
  @override
  _AppCheckState createState() => _AppCheckState(app);
}

class _AppCheckState extends State<AppCheck> {
  App app;
  _AppCheckState(this.app);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Checkbox(
              onChanged: (bool value) {
                setState(() {
                  widget.app.monitor = value;
                });
                widget.app.timeLimit = widget.app.timeLimit;
              },
              value: widget.app.monitor,
              activeColor: Color(0xFF6200EE),
            ),
            Expanded(child: Text(widget.app.name)),
            TextButton(
                onPressed: null,
                child: Text(widget.app.timeLimit
                    .toString()
                    .split('.')
                    .first
                    .padLeft(8, "0"))),
          ],
        ));
    //Text(widget.app.name);
  }
}
