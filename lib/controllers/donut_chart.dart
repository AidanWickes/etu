  
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

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(
      arcWidth: 15,
    ),
    );
    
  }
  
static List<charts.Series<Purchases, String>> _createPurchaseData() {
  final data = [
    new Purchases("Eating Out", 90, charts.Color(r: 8, g: 61, b: 119)),
    new Purchases("Groceries", 75, charts.Color(r: 125, g: 131, b: 255)),
    new Purchases("Shopping", 25, charts.Color(r: 44, g: 165, b: 181)),
    new Purchases("Traveling", 15, charts.Color(r: 159, g: 231, b: 156)),
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
