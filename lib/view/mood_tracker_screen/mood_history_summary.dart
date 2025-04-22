import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stress_managment_app/presenter/mood_tracker_presenter.dart';
import 'package:stress_managment_app/view/mood_tracker_screen/mood_tracker_bar.dart';

class MoodHistorySummary extends StatelessWidget {
  final MoodTrackerPresenter _presenter =
      MoodTrackerPresenter(firestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return Container(

      // BACKGROUND IMAGE
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/purple_background.jpg"),
          fit: BoxFit.cover,
        ),
      ),


      child: StreamBuilder(
        stream: _presenter.getMoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("NOTHING SAVED YET!"));
          }

          final moods = snapshot.data!;
          int happyCount = 0;
          int neutralCount = 0;
          int sadCount = 0;
          int angryCount = 0;

          for (var mood in moods) {
            switch (mood.mood) {
              case 'happy':
                happyCount++;
                break;
              case 'neutral':
                neutralCount++;
                break;
              case 'sad':
                sadCount++;
                break;
              case 'angry':
                angryCount++;
                break;
            }
          }

          // MAP TO THE MOST FREQUENT MOOD
          Map<String, int> moodCounts = {
            'happy': happyCount,
            'neutral': neutralCount,
            'sad': sadCount,
            'angry': angryCount,
          };
          String mostFrequentMood =
              moodCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

          // MAP THE MOOD TO DESIGNATED EMOJI
          Map<String, String> moodEmojis = {
            'happy': '😊',
            'neutral': '😐',
            'sad': '😢',
            'angry': '😠',
          };

          // DISPLAY MESSAGE
          String moodEmoji = moodEmojis[mostFrequentMood] ?? '';
          String moodMessage =
              "the mood you've been frequently feeling is $moodEmoji ${mostFrequentMood.toUpperCase()}!";

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // MOOD MESSAGE
              Padding(
                padding: const EdgeInsets.all(23.0),
                child: Text(
                  moodMessage,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),

              // DISPLAY BAR CHART
              Expanded(
                child: MoodTrackerBarChart(
                  happyCount: happyCount,
                  neutralCount: neutralCount,
                  sadCount: sadCount,
                  angryCount: angryCount,
                ),
              ),
              SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
