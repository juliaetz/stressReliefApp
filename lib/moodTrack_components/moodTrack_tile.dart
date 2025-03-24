import 'package:flutter/material.dart';


class MoodtrackTile extends StatelessWidget {
  const MoodtrackTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        // "SELECT YOUR MOOD"
        Container(
          padding: EdgeInsets.all(5),
          child: Text(
            "SELECT YOUR MOOD:",
            style: TextStyle(
              color: Colors.indigo[900],
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),


        // ANGRY ICON
        SizedBox(
          child: Image.asset(
            height: 65,
            width: 65,
            'lib/moodTrack_components/face_icons/angry.png',
            color: Colors.red[600],
          ),
        ),


        // SAD ICON
        SizedBox(
          child: Image.asset(
            height: 60,
            width: 60,
            'lib/moodTrack_components/face_icons/sad-face.png',
            color: Colors.blue[700],
          ),
        ),


        // NEUTRAL ICON
        SizedBox(
          child: Image.asset(
            height: 60,
            width: 60,
            'lib/moodTrack_components/face_icons/neutral-face.png',
            color: Colors.amber[700],
          ),
        ),


        // HAPPY ICON
        SizedBox(
          child: Image.asset(
            height: 60,
            width: 60,
            'lib/moodTrack_components/face_icons/happiness.png',
            color: Colors.lightGreen[700],
          ),
        ),

      ],
    );
  }
}