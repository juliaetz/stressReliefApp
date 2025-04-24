//import 'dart:ffi';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:stress_managment_app/presenter/history_presenter.dart';
import 'package:stress_managment_app/presenter/journal_presenter.dart';
import 'package:stress_managment_app/presenter/selfcare_presenter.dart';
import 'package:stress_managment_app/view/history_component.dart';
import 'package:stress_managment_app/view/rewards_view.dart';
import 'package:stress_managment_app/view/journal_view.dart';
import 'package:stress_managment_app/view/selfcare_component.dart';
import '../auth_gate.dart';
import 'calendar_view.dart';
import '../model/calendar_model.dart';
import '../presenter/calendar_presenter.dart';
import 'mood_tracker_screen/mood_tracker_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//class to help create buttons
class Button extends StatelessWidget {
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
  Widget build(BuildContext context) {
    //creates a button and assigns what page it goes to by checking its PageID value
    return ElevatedButton.icon(
      onPressed: () {
        //check the given page id, and move to the page corresponding to the id.
        if (pageID == 1) {
          // Navigate to PlannerPage
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CalendarView(presenter: CalendarPresenter(CalendarModel())),
              ));
        } else if (pageID == 2) {
          // Navigate to Mood Tracker Page
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MoodTrackerView()));
        } else if (pageID == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HistoryPage(BasicHistoryPresenter(),
                    title: 'HISTORY', key: const Key('HISTORY'))),
          );
        } else if (pageID == 4) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder:(context) =>
                    JournalView(presenter: JournalPresenter(firestore: FirebaseFirestore.instance),),)
          );
        } else if(pageID == 5){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RewardsView()));
        } else if (pageID == 6) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelfcarePage(BasicSelfcarePresenter(),
                    title: 'SELFCARE', key: const Key('SELFCARE'))),
          );
        }
      },
      icon: Icon(icon),
      label: Text(label),
      //dictates the size of the button
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(150, 75),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AuthGate()));
                      })
                    ],
                  ),

                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
        title: Text('Home Page'),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/purple_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
       child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'OVERWORKED?',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Ease your stress~',
              style: TextStyle(
                fontSize: 20,
              ),
            ),

            SizedBox(
              height: 40,
            ), //space between title and buttons
            // Planner Button
            Button(
                icon: Icons.calendar_month_outlined,
                label: 'Planner',
                pageID: 1),
            SizedBox(height: 20), // Space between buttons
            //Mood Tracker Button
            Button(icon: Icons.tag_faces, label: 'Mood Tracker', pageID: 2),
            SizedBox(height: 20), // Space between buttons
            //Activity History Button
            Button(icon: Icons.timer, label: 'Activity History', pageID: 3),
            SizedBox(height: 20),
            Button(icon: Icons.create, label: 'Journal', pageID: 4),
            SizedBox(height: 20), // Space between buttons
            //Rewards Button
            Button(icon: Icons.lock, label: 'Rewards', pageID: 5),
            SizedBox(height: 20), // Space between buttons
            Button(icon: Icons.star, label: 'Self Care Ideas', pageID: 6),
          ],
        ),
      ),
      ),
    );
  }
}
