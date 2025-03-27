import 'package:flutter/material.dart';


class MoodtrackTile extends StatefulWidget {
  @override
  _MoodTrackTileState createState() => _MoodTrackTileState();
}

class _MoodTrackTileState extends State<MoodtrackTile> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        
        // TEXT "SELECT YOUR MOOD:"
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



        // ANGRY ICON BUTTON WITH RIPPLE EFFECT
        InkWell(
          onTap: () {
            // will add function when pressed
          },
          splashColor: Colors.pink[900],
          borderRadius: BorderRadius.circular(10),
          onTapDown: (_) {
            setState(() {
              _scale = 0.9; // scale down when clicked
            });
          },
          onTapUp: (_) {
            setState(() {
              _scale = 1.0; // scale to normal
            });
          },
          onTapCancel: () {
            setState(() {
              _scale = 1.0; // reset scale
            });
          },
          child: Transform.scale(
            scale: _scale,
            child: Image.asset(
              'lib/presenter/moodTrack_components/face_icons/angry.png',
              width: 65,
              height: 65,
              color: Colors.pink[700],
            ),
          ),
        ),



        // SAD ICON BUTTON WITH RIPPLE EFFECT
        InkWell(
          onTap: () {
            // will add function when pressed
          },
          splashColor: Colors.cyan[900],
          borderRadius: BorderRadius.circular(10),
          onTapDown: (_) {
            setState(() {
              _scale = 0.9;
            });
          },
          onTapUp: (_) {
            setState(() {
              _scale = 1.0;
            });
          },
          onTapCancel: () {
            setState(() {
              _scale = 1.0;
            });
          },
          child: Transform.scale(
            scale: _scale,
            child: Image.asset(
              'lib/presenter/moodTrack_components/face_icons/sad-face.png',
              width: 60,
              height: 60,
              color: Colors.cyan[700],
            ),
          ),
        ),


        // NEUTRAL ICON BUTTON WITH RIPPLE EFFECT
        InkWell(
          onTap: () {
            // will add function when pressed
          },
          splashColor: Colors.amber[400],
          borderRadius: BorderRadius.circular(10),
          onTapDown: (_) {
            setState(() {
              _scale = 0.9;
            });
          },
          onTapUp: (_) {
            setState(() {
              _scale = 1.0;
            });
          },
          onTapCancel: () {
            setState(() {
              _scale = 1.0;
            });
          },
          child: Transform.scale(
            scale: _scale,
            child: Image.asset(
              'lib/presenter/moodTrack_components/face_icons/neutral-face.png',
              width: 60,
              height: 60,
              color: Colors.yellow[600],
            ),
          ),
        ),


        // HAPPY ICON BUTTON WITH RIPPLE EFFECT
        InkWell(
          onTap: () {
            // will add function when pressed
          },
          splashColor: Colors.green[900],
          borderRadius: BorderRadius.circular(10),
          onTapDown: (_) {
            setState(() {
              _scale = 0.9;
            });
          },
          onTapUp: (_) {
            setState(() {
              _scale = 1.0;
            });
          },
          onTapCancel: () {
            setState(() {
              _scale = 1.0;
            });
          },
          child: Transform.scale(
            scale: _scale,
            child: Image.asset(
              'lib/presenter/moodTrack_components/face_icons/happiness.png',
              width: 60,
              height: 60,
              color: Colors.greenAccent[400],
            ),
          ),
        ),



      ],
    );
  }
}