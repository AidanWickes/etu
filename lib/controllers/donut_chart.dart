import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:wellbeing_app/models/purchases.dart';

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});

  factory DonutPieChart.withSampleData() {
    return new DonutPieChart(
      _createPurchaseData(),
      animate: true,
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

  static List<charts.Series<Purchases, String>> _createPurchaseData() {
    final data = [
      new Purchases("Instagram", 90, charts.Color(r: 193, g: 53, b: 132)),
      new Purchases("Facebook", 75, charts.Color(r: 66, g: 103, b: 178)),
      new Purchases("Youtube", 25, charts.Color(r: 255, g: 0, b: 0)),
      new Purchases("Snapchat", 15, charts.Color(r: 255, g: 252, b: 0)),
    ];

    return [
      new charts.Series<Purchases, String>(
        id: 'Purchases',
        domainFn: (Purchases purchases, _) => purchases.category,
        measureFn: (Purchases purchases, _) => purchases.amount,
        data: data,
        colorFn: (Purchases purchases, _) => purchases.color,
      )
    ];
  }
}
