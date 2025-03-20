import 'package:flutter/material.dart';

class MoodtrackPage extends StatelessWidget {
  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mood Tracker')),
      body: Center(
        child: Text('How are you feeling?'),
      ),
    );
  }
}