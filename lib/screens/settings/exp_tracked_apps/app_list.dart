import 'package:flutter/material.dart';
import 'package:wellbeing_app/models/apps.dart';
import 'package:wellbeing_app/screens/settings/exp_tracked_apps/checked_apps.dart';

class AppList extends StatefulWidget {
  final List<App> app;
  AppList(this.app);

  @override
  _AppListState createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: widget.app.length,
      // A callback that will return a widget.
      itemBuilder: (context, int) {
        // In our case, a DogCard for each doggo.
        return AppCheck(widget.app[int]);
      },
    ));

    //return _buildList(context);
  }

  ListView _buildList(context) {
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: widget.app.length,
      // A callback that will return a widget.
      itemBuilder: (context, int) {
        // In our case, a DogCard for each doggo.
        return AppCheck(widget.app[int]);
      },
    );
  }
}
