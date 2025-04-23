import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodTrackerChart extends StatefulWidget {
  final int happyCount, neutralCount, sadCount, angryCount;

  const MoodTrackerChart({
    Key? key,
    required this.happyCount,
    required this.neutralCount,
    required this.sadCount,
    required this.angryCount,
  }) : super(key: key);

  @override
  State<MoodTrackerChart> createState() => _MoodTrackerChartState();
}

class _MoodTrackerChartState extends State<MoodTrackerChart> {
  // KEEP TRACK OF WHICH SECTION IS TOUCHED
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // LABELS
    final moods = ['HAPPY', 'NEUTRAL', 'SAD', 'ANGRY'];

    final counts = [
      widget.happyCount,
      widget.neutralCount,
      widget.sadCount,
      widget.angryCount
    ];
    final colors = [
      Colors.greenAccent[400]!,
      Colors.yellow[600]!,
      Colors.cyan[500]!,
      Colors.pink[700]!,
    ];

    // COUNTS TOTAL MOOD ENTRIES TO CONVERT TO PERCENTAGE
    final total = counts.fold(0, (sum, value) => sum + value);

    // USE ASPECT RATIO FOR SPACING AND CHART ANIMATION
    return AspectRatio(
      aspectRatio: 2.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  // PIE CHART ANIMATION
                  pieTouchData: PieTouchData(
                    touchCallback: (event, pieTouchResponse) {
                      setState(() {
                        // RESET TOUCH INDEX IF NOTHING IS BEING TOUCHED
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        // SET TOUCHED INDEX TO "HIGHLIGHTED" SECTION
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),

                  borderData: FlBorderData(show: false),
                  sectionsSpace: 7,
                  centerSpaceRadius: 50,

                  // PIE CHART SECTIONS
                  sections: List.generate(4, (i) {
                    final isTouched = i == touchedIndex;
                    final double radius = isTouched ? 110 : 90;
                    final double fontSize = isTouched ? 27 : 17;
                    final shadows = [
                      const Shadow(color: Colors.black45, blurRadius: 2)
                    ];

                    // CALCULATE PERCENTAGE FOR EACH SECTION
                    final percentage = total == 0
                        ? 0
                        : ((counts[i] / total) * 100).toStringAsFixed(0);

                    // FORMAT PIE CHART SECTIONS
                    return PieChartSectionData(
                      color: colors[i],
                      value: counts[i].toDouble(),
                      // NUMERIC VALUE FORM
                      title: '$percentage%',
                      // ONLY SHOW PERCENTAGE
                      radius: radius,
                      titleStyle: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        shadows: shadows,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
