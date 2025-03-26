//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'calendar_view.dart';
import '../model/calendar_model.dart';
import '../presenter/calendar_presenter.dart';
import '../view/moodTrack_view.dart'; // Import Mood Tracker Page

//class to help create buttons
class Button extends StatelessWidget{
  const Button({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  //creates a button using an icon and a label as a
  //currently all buttons go to the planner page as a placeholder
  @override
  Widget build(BuildContext context){
    return ElevatedButton.icon(
      onPressed: () {
        // Navigate to PlannerPage
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CalendarView(presenter: CalendarPresenter(CalendarModel({}))),
        )
        );
      },
      icon: Icon(icon),
      label: Text(label),
      //dictates the size of the button
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(150,75),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = CalendarModel({}); //creating an instance of calender model
    final calPresenter = CalendarPresenter(model); //

    return Scaffold(
      appBar: AppBar(
          title: Text('Home Page'),
          backgroundColor: Colors.deepPurple.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Placeholder Title',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40,), //space between title and buttons
            //creates the 3 buttons
            Button(icon: Icons.calendar_month_outlined, label: 'Planner'),
            SizedBox(height: 20), // Space between buttons
            Button(icon: Icons.tag_faces, label: 'Mood Tracker'),
            SizedBox(height: 20), // Space between buttons
            Button(icon: Icons.timer, label: 'Activity History'),
          ],
        ),
      ),
    );
  }
}
