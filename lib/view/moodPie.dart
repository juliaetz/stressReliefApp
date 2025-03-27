import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


// TEMPORARY PIE CHART TEMPLATE TO ADD DATA LATER

class Moodpie extends StatelessWidget{
  const Moodpie({super.key});

  @override
  Widget build(BuildContext context){
    return PieChart(
      PieChartData(
        sections: showColorSections(),
      )
    );
  }

  List<PieChartSectionData> showColorSections(){
    return List.generate(4, (i){
      final isTouched = i ==1;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      switch(i){
        case 0:
          return PieChartSectionData(
            color: Colors.pink[700],
            value: 3,
            title: 'ANGRY',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.pink[100],
            ),
          );
          case 1:
            return PieChartSectionData(
              color: Colors.cyan[700],
              value: 4,
              title: 'SAD',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.cyan[100],
              ),
            );
          case 2:
            return PieChartSectionData(
              color: Colors.yellow[600],
              value: 7,
              title: 'NEUTRAL',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.yellow[800],
              ),
            );
          case 3:
            return PieChartSectionData(
              color: Colors.greenAccent[400],
              value: 10,
              title: 'HAPPY',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            );
          default:
            throw Error();
      }
    });
  }
}
