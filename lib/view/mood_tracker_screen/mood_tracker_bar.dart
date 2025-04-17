import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class MoodTrackerBarChart extends StatelessWidget {
  final int happyCount, neutralCount, sadCount, angryCount;


  const MoodTrackerBarChart({
    Key? key,
    required this.happyCount,
    required this.neutralCount,
    required this.sadCount,
    required this.angryCount,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // MOOD LABELS FOR EACH BAR
    final moods = ['HAPPY', 'NEUTRAL', 'SAD', 'ANGRY'];

    // GET MOOD COUNTS FOR EACH BAR
    final counts = [happyCount, neutralCount, sadCount, angryCount];

    final colors = [
      Colors.greenAccent[400]!,
      Colors.yellow[600]!,
      Colors.cyan[700]!,
      Colors.pink[700]!
    ];



    return BarChart(
      BarChartData(
        // SET MAX Y VALUE TO HIGHEST MOOD COUNT + 2 FOR PADDING
        maxY: (counts.reduce((a, b) => a > b ? a : b) + 2).toDouble(),


        // BAR GROUP -- ONE FOR EACH MOOD
        barGroups: List.generate(4, (i) {
          return BarChartGroupData(
            x: i, // X POSITION OF THE BAR
            barRods: [
              BarChartRodData(
                toY: counts[i].toDouble(), // HEIGHT OF BAR FOR MOOD COUNT
                color: colors[i],
                width: 27,
                borderRadius: BorderRadius.circular(35), // MAKES ROUNDED CORNERS
              ),
            ],
          );
        }),



        // BAR LABELS
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            // SHOW MOOD LABEL FOR EACH BAR
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  moods[value.toInt()],
                  style: const TextStyle(fontSize: 15),
                );
              },
            ),
          ),



          // REMOVE ALL AXIS TITLES
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),

        // REMOVE CHART BORDER
        borderData: FlBorderData(show: false),

      ),
    );
  }
}
