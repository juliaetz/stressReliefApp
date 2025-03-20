import 'package:flutter/material.dart';
import 'calendar_view.dart';
import 'calendar_model.dart';
import 'calendar_presenter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = CalendarModel({}); //creating an instance of calender model

    final calPresenter = CalendarPresenter(model); //

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
                  MaterialPageRoute(
                      builder: (context) => CalendarView(presenter: calPresenter)),
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
