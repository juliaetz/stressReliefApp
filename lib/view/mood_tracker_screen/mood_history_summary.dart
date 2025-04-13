import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stress_managment_app/presenter/mood_tracker_presenter.dart';


class MoodHistorySummary extends StatefulWidget{
  @override
  _MoodHistorySummaryState createState() => _MoodHistorySummaryState();
}


class _MoodHistorySummaryState extends State<MoodHistorySummary>{
  final MoodTrackerPresenter _presenter = MoodTrackerPresenter(firestore: FirebaseFirestore.instance);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text("Mood Summary"),
      ),

      body: Column(
        children: [
          




        ],
      ),
    );
  }
}