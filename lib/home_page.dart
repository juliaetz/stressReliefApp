import 'package:flutter/material.dart';
import 'planner_page.dart'; // Import the Planner Page


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
            top: 400, // Distance from the top
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
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Planner'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150,75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
