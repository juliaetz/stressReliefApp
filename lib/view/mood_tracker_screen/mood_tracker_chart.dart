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

  int touchedIndex = -1;


  @override
  Widget build(BuildContext context){
    
    final moodChartData = [
      PieChartSectionData(
        value: happyCount.toDouble(),
        color: Colors.greenAccent[400],
        title: 'HAPPY\n$happyCount',
        radius: 70,
      ),
      PieChartSectionData(
        value: neutralCount.toDouble(),
        color: Colors.yellow[600],
        title: 'NEUTRAL\n$neutralCount',
        radius: 70,
      ),
      PieChartSectionData(
        value: sadCount.toDouble(),
        color: Colors.cyan[700],
        title: 'SAD\n$sadCount',
        radius: 70,
      ),
      PieChartSectionData(
        value: angryCount.toDouble(),
        color: Colors.pink[700],
        title: 'ANGRY\n$angryCount',
        radius: 70,
      ),
    ];

    return PieChart(
      PieChartData(
        
        sections: moodChartData,
        borderData: FlBorderData(show: true),
        sectionsSpace: 5,
        centerSpaceRadius: 60,
      ),
    );
  }
  
}