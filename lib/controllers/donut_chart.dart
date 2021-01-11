import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:wellbeing_app/models/apps.dart';
import 'package:wellbeing_app/models/purchases.dart';

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});

  factory DonutPieChart.withSampleData() {
    return new DonutPieChart(
      _createPurchaseData(),
      animate: false,
    );
  }

  //any visual widgets need a build context widget to be created and shown on screen
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        charts.PieChart(
          seriesList,
          animate: animate,
          defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 15,
          ),
        ),
        Center(
          child: Text(
            "Today",
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 50.0,
                fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }

  static List<charts.Series<App, String>> _createPurchaseData() {
    final List<App> data = [];
    initialApps.forEach((App app) {
      if (app.monitor) {
        data.add(app);
      }
    });

    return [
      new charts.Series<App, String>(
        id: 'Purchases',
        domainFn: (App apps, _) => apps.name,
        measureFn: (App apps, _) => apps.time.inMinutes,
        data: data,
        colorFn: (App apps, _) =>
            charts.Color.fromHex(code: '#' + apps.color.substring(4)),
      )
    ];
  }
}
