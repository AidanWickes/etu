import 'package:flutter/material.dart';
import 'package:wellbeing_app/models/apps.dart';
import 'package:wellbeing_app/screens/settings/exp_tracked_apps/app_list.dart';

class SettingsTest extends StatefulWidget {
  @override
  _SettingsTestState createState() => _SettingsTestState();
}

class _SettingsTestState extends State<SettingsTest> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppList(initialApps),
      ],
    );
  }
}
