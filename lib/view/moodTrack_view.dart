import 'package:flutter/material.dart';
import 'package:stress_managment_app/presenter/moodTrack_components/moodTrack_tile.dart';
import 'package:stress_managment_app/view/moodPie.dart';
import 'package:intl/intl.dart';

class MoodtrackPage extends StatefulWidget{
  const MoodtrackPage({super.key});

  @override
  State<MoodtrackPage> createState() => _MoodtrackPageState();
}


class _MoodtrackPageState extends State<MoodtrackPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      //backgroundColor: Colors.deepPurple[50],
      // APPBAR
      appBar: AppBar(
        title: Text("MOOD TRACKER", 
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade200,
      ),


      body: ListView(
        children: [
          SizedBox(height: 20),  // spacing

          // CURRENT DATE
          Center(
            child: Text(
              "Today is " + DateFormat("yMMMMd").format(DateTime.now()),
              style: TextStyle(
                color: Colors.deepPurple[800],
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            )
          ),
          SizedBox(height: 20), // spacing


          // MOOD TRACKER FACE BUTTONS
          MoodtrackTile(),
          SizedBox(height: 20), // spacing


          // PIE CHART
          ListTile(
            subtitle: SizedBox(
              height: 300,
              width: 300,
              child: Moodpie()
            ),
          ),
          SizedBox(height: 30), // spacing


          // TEXT FIELD FOR USER TO ENTER NOTES (thoughts, feelings, etc.)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "How are you feeling?",
              ),
            ),
          ),
        ],
      ),


    );
  }
}