import 'package:flutter/material.dart';
import 'planner_page.dart'; // Import the Planner Page

class Button extends StatelessWidget{
  const Button({
    super.key,
    required this.icon,
    required this.label,
    required this.height,
  });

  final IconData icon;
  final String label;
  final double? height;


  @override
  Widget build(BuildContext context){
    return Positioned(
      top: height, // Distance from the top
      right: 125,
      // Distance from the right
      child: ElevatedButton.icon(
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
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Stack(
        children: [
          // Main content of the home page
          Center(child: Text('Welcome to the Home Page!')),
          // Planner button positioned at the top-right
          Button(icon: Icons.calendar_month_outlined, label: 'Planner', height: 400),
          Button(icon: Icons.tag_faces, label: 'Mood Tracker', height: 500),
          Button(icon: Icons.timer, label: 'Activity History', height: 600),

        ],
      ),
    );
  }
}
