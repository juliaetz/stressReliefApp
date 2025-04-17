import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stress_managment_app/presenter/mood_tracker_presenter.dart';
import 'package:stress_managment_app/view/mood_tracker_screen/mood_tracker_bar.dart';

// MOOD OPTIONS
enum MoodType { happy, neutral, sad, angry }

// MAKE THE PAGE
class MoodHistorySummary extends StatefulWidget {
  @override
  _MoodHistorySummaryState createState() => _MoodHistorySummaryState();
}

class _MoodHistorySummaryState extends State<MoodHistorySummary> {
  final MoodTrackerPresenter _presenter =
      MoodTrackerPresenter(firestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text("Mood Summary"),
      ),
      body: Column(
        children: [
          SizedBox(height: 100),

          // DISPLAY SAVED MOODS FROM DATABASE ON CHART
          Expanded(
            child: StreamBuilder(
                stream: _presenter.getMoods(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No moods saved yet!"));
                  }
                  final moods = snapshot.data!;

                  // COUNT THE USER CLICKS
                  int happyCount = 0;
                  int neutralCount = 0;
                  int sadCount = 0;
                  int angryCount = 0;

                  for (var mood in moods) {
                    if (mood.mood == 'happy') {
                      happyCount++;
                    } else if (mood.mood == 'neutral') {
                      neutralCount++;
                    } else if (mood.mood == 'sad') {
                      sadCount++;
                    } else if (mood.mood == 'angry') {
                      angryCount++;
                    }
                  }

                  // DISPLAY BAR CHART
                  return MoodTrackerBarChart(
                      happyCount: happyCount,
                      neutralCount: neutralCount,
                      sadCount: sadCount,
                      angryCount: angryCount);
                }),
          ),

          SizedBox(height: 100),
        ],
      ),
    );
  }
}
