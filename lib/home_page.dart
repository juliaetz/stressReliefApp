import 'package:flutter/material.dart';
import 'planner_page.dart'; // Import the Planner Page

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to PlannerPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlannerPage()),
            );
          },
          child: Text('Go to Planner'),
        ),
      ),
    );
  }
}
