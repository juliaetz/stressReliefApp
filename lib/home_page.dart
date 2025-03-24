import 'package:flutter/material.dart';
import 'planner_page.dart'; // Import the Planner Page
import 'moodTrack_pages/moodTrack_page.dart'; // Import Mood Tracker Page


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
          Positioned(
            top: 20, // Distance from the top
            right: 20, // Distance from the right
            child: ElevatedButton(
              onPressed: () {
                // Navigate to PlannerPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlannerPage()),
                );
              },
              child: Text('Planner'),
            ),
          ),
        ],
      ),
    );
  }
}
