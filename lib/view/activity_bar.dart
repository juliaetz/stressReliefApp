
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityBarChart extends StatelessWidget {
  //everything will go into the build function
  const ActivityBarChart({Key? key, required this.eventCounts}) : super(key: key);
  final Map<String, int> eventCounts;

  @override
  Widget build(BuildContext context) {
    final days = eventCounts.keys.toList(); // Should be ordered Mon, Tue, etc.
    final counts = eventCounts.values.toList();

    final colors = [
      Colors.lightBlueAccent,
      Colors.orangeAccent,
      Colors.green,
      Colors.redAccent,
      Colors.purpleAccent,
      Colors.teal,
      Colors.amber,
    ];

    return BarChart(
      BarChartData(
        maxY: (counts.isEmpty ? 0 : counts.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
        barGroups: List.generate(days.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: counts[i].toDouble(),
                color: colors[i % colors.length],
                width: 22,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= days.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    days[value.toInt()].substring(0, 3).toUpperCase(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 1),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}




