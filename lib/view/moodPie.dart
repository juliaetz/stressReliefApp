import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


// TEMPORARY PIE CHART TEMPLATE TO ADD DATA LATER

class Moodpie extends StatelessWidget{
  const Moodpie({super.key});

  @override
  Widget build(BuildContext context){
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 20,
            color: Colors.red[700],
          )
        ]
      )
    );
  }
}
