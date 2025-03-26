import 'package:flutter/material.dart';
import 'package:stress_managment_app/moodTrack_components/moodTrack_tile.dart';


class MoodtrackPage extends StatefulWidget{
  const MoodtrackPage({super.key});

  @override
  State<MoodtrackPage> createState() => _MoodtrackPageState();
}


class _MoodtrackPageState extends State<MoodtrackPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.indigo[100],


      // APPBAR
      appBar: AppBar(
        title: Text("MOOD TRACKER", 
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent[100],
      ),


      // MOOD TRACKER FACE BUTTONS
      body: ListView(
        children: [
          MoodtrackTile(),
        ]
      )

    );
  }
}