import 'package:flutter/material.dart';
import 'package:wellbeing_app/controllers/donut_chart.dart';

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}
    class _TimerState extends State<Timer> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SizedBox(
          height: 300,
          child: DonutPieChart.withSampleData(),
        ),
      ),
      
    );
  }
}

