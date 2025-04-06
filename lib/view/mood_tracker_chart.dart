import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodTrackerChart extends StatelessWidget{
  final int happyCount, neutralCount, sadCount, angryCount;

  MoodTrackerChart({
    required this.happyCount, 
    required this.neutralCount, 
    required this.sadCount,
    required this.angryCount,
  });

  @override
  Widget build(BuildContext context){
    
    final moodChartData = [
      PieChartSectionData(
        value: happyCount.toDouble(),
        color: Colors.greenAccent[400],
        title: 'Happy\n$happyCount',
        radius: 50,
      ),
      PieChartSectionData(
        value: neutralCount.toDouble(),
        color: Colors.yellow[600],
        title: 'Neutral\n$neutralCount',
        radius: 50,
      ),
      PieChartSectionData(
        value: sadCount.toDouble(),
        color: Colors.cyan[700],
        title: 'Sad\n$sadCount',
        radius: 50,
      ),
      PieChartSectionData(
        value: angryCount.toDouble(),
        color: Colors.pink[700],
        title: 'Angry\n$angryCount',
        radius: 50,
      ),
    ];

    return PieChart(
      PieChartData(
        sections: moodChartData,
        borderData: FlBorderData(show: true),
        sectionsSpace: 3,
        centerSpaceRadius: 50,
      ));
  }
}