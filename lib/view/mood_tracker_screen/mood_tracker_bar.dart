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
      Colors.cyan[500]!,
      Colors.pink[700]!
    ];


    return BarChart(
      BarChartData(
        // SET MAX Y-VALUE TO HIGHEST MOOD COUNT + 1 FOR PADDING
        maxY: (counts.reduce((a, b) => a > b ? a : b) + 1).toDouble(),


        // BAR GROUP -- ONE FOR EACH MOOD
        barGroups: List.generate(4, (i) {
          return BarChartGroupData(
            x: i, // X POSITION OF A BAR
            barRods: [
              BarChartRodData(
                toY: counts[i].toDouble(), // HEIGHT OF BAR FOR MOOD COUNT
                color: colors[i],
                width: 34,
                borderRadius: BorderRadius.circular(30), // MAKES ROUNDED CORNERS
              ),
            ],
          );
        }),


        // LABELS AND TITLES AROUND CHART
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  moods[value.toInt()],
                  style: const TextStyle(fontSize: 15, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),


          // Y-AXIS SHOWS NUMBER LABELS FOR EVERY 2 UNITS
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (value, meta) {
                // ONLY SHOWS EVEN NUMBERS
                if (value % 2 == 0) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                } else {
                  return const SizedBox.shrink(); // HIDES THE ODD NUMBERS
                }
              },
            ),
          ),


          // Y-AXIS RIGHT SIDE SHOWS NUMBER LABELS FOR EVERY 2 UNITS
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (value, meta){
                if(value % 2 == 0){
                  return Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }
            ),
          ),


          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),

        // SHOW BORDERS, HIDE GRIDLINES
        borderData: FlBorderData(show: true),
        gridData: FlGridData(show: false),
      ),
    );
  }
}
