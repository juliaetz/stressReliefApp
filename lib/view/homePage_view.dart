//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:stress_managment_app/presenter/history_presenter.dart';
import 'calendar_view.dart';
import '../model/calendar_model.dart';
import '../presenter/calendar_presenter.dart';
import '../view/moodTrack_view.dart';

//class to help create buttons
class Button extends StatelessWidget{
  const Button({
    super.key,
    required this.icon,
    required this.label,
    required this.pageID,
  });

  final IconData icon;
  final String label;
  final int pageID;
  //creates a button using an icon and a label as a
  //currently all buttons go to the planner page as a placeholder
  @override
  Widget build(BuildContext context){
    return ElevatedButton.icon(
      onPressed: () {
        //check the given page id, and move to the page corresponding to the id.
        if(pageID == 1){
          // Navigate to PlannerPage
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalendarView(presenter: CalendarPresenter(CalendarModel({}))),
              )
          );
        }else if(pageID == 2){
          //placeholder
        }else if(pageID == 3){
          //placeholder
        }



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


            // Planner Button
            Button(icon: Icons.calendar_month_outlined, label: 'Planner'),


            SizedBox(height: 20), // Space between buttons


            // Navigate to Mood Tracker Page
            ElevatedButton.icon(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoodtrackPage()
                  ),
                );
              }, 
              icon: Icon(Icons.tag_faces), 
              label: Text('Mood Tracker'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150,75),
              ),
            ),


            SizedBox(height: 20), // Space between buttons



            // CAN UN-COMMENT THIS WHEN READY TO USE
            /*
            // Navigate to Activity History Page
            ElevatedButton.icon(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),     // UPDATE THIS LINE SO BUTTON CAN NAVIGATE TO PAGE
                );
              }, 
              icon: Icon(Icons.timer), 
              label: Text('Activity History'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150,75),
              ),
            ),
            */


            // Activity History Button 
            Button(icon: Icons.timer, label: 'Activity History'),

          ],
        ),
      ),
    );
  }
}
