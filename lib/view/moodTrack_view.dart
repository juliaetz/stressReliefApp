import 'package:flutter/material.dart';
import 'package:stress_managment_app/presenter/moodTrack_components/moodTrack_tile.dart';
import 'package:stress_managment_app/view/moodPie.dart';

class MoodtrackPage extends StatefulWidget{
  const MoodtrackPage({super.key});

  @override
  State<MoodtrackPage> createState() => _MoodtrackPageState();
}


class _MoodtrackPageState extends State<MoodtrackPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],


      // APPBAR
      appBar: AppBar(
        title: Text("MOOD TRACKER", 
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[300],
      ),


      // MOOD TRACKER FACE BUTTONS
      body: ListView(
        children: [
          SizedBox(height: 20),
          MoodtrackTile(),
          SizedBox(height: 20),
          ListTile(
            subtitle: SizedBox(
              height: 300,
              width: 300,
              child: Moodpie()
            )
          ),
        ]
      )


    );
  }
}