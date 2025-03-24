import 'package:flutter/material.dart';
import 'planner_page.dart'; // Import the Planner Page

//class to help create buttons
class Button extends StatelessWidget{
  const Button({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  //takes in a icon, label, and height and creates a button with it.
  //currently all buttons go to the planner page, but this will change as
  //more pages are finished.
  @override
  Widget build(BuildContext context){
    return ElevatedButton.icon(
        onPressed: () {
          // Navigate to PlannerPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlannerPage()),
          );
        },
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150,75),
        ),
      );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Placeholder App Title')),
      body: Center(
        // Main content of the home page
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
            SizedBox(height: 40,),
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