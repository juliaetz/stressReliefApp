import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stress_managment_app/firebase_logic.dart';

//this is pretty much a complete overhaul of the previous calendar_model
//this version removed the previous map<DateTime, map<<Events> <TimeOfDay>>> because we couldnt convert DateTime to
//a format that could be stored in our firebase


class CalendarModel {
  // Formats DateTime as a string for our 'date' field in
  //you HAVE to store it as a string or it gets really mad
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  // Adds an event to Firestore
  Future<void> addEvent(DateTime date, String event, TimeOfDay time) async {
    String formattedDate = _formatDate(date);


    // Convert TimeOfDay to a map
    Map<String, int> timeData = {'hour': time.hour, 'minute': time.minute};


    //A DocumentReference refers to a document location in our firebase
    //database and can be used to write, read, or listen to the location.
    final userDocRef = await getUserDocument();
    if (userDocRef == null) {
      return; // No user is signed in
    }
    DocumentReference docRef = userDocRef.collection('events').doc(formattedDate);


    //set our 'date' field with our date parameter.
    //Our 'events' field in our firebase has two collections, 'time' and 'event'
    //'event' is just a string. 'time' is a TimeOfDay object. Look at _formatDate() function above for explanation
    await docRef.set({
      'date': Timestamp.fromDate(date),
      'events': FieldValue.arrayUnion([
        {'time': timeData, 'description': event}
      ])
    }, SetOptions(merge: true));
  }

  // Removes an event from Firestore
  Future<void> deleteEvent(DateTime date, String event) async {
    //convert the date to the format we are using in our firestore
    String formattedDate = _formatDate(date);

    //specify that we want the to remove the data at our 'formattedDate' which will be inside our 'events' collection
    final userDocRef = await getUserDocument();
    if (userDocRef == null) {
      return; // No user is signed in
    }
    DocumentReference docRef = userDocRef.collection('events').doc(formattedDate);

    //Check that we're removing something that actually exists
    DocumentSnapshot doc = await docRef.get();
    if (doc.exists) {

      //retrieve our 'events' field from our firestore
      // 'doc.data() as Map<String, dynamic>' casts the result of doc.data() to our Map.
      //Essentially this tells Dart to expect the result od doc.data() to be a map where keys are Strings and their values are dynamic
      // ?? <- this operator checks if the expression to the left of it is null. in our case, if it is null, return an empty array []
      List<dynamic> events = (doc.data() as Map<String, dynamic>)['events'] ?? [];

      //e is a parameter that represents an individual element in our events list. in our case, since events is a list of maps,
      //e will be each map in the list. We just simply remove the data at the 'description' position of our e iteration.
      events.removeWhere((e) => e['description'] == event);

      // before we update, we check if the document is empty. if it is we delete the doc from firebase
      if (events.isEmpty) {
        await docRef.delete();
      } else {
        //call the update function on our events field with our changed events
        await docRef.update({'events': events});
      }
    }
  }

  // Retrieves events for a specific date from Firestore
  Future<List<Map<String, dynamic>>> getEventsForDay(DateTime date) async {
    String formattedDate = _formatDate(date);
    //print("Fetching events for: $formattedDate"); // Debugging print leave for if things break

    final userDocRef = await getUserDocument();
    if (userDocRef == null) {
      return List<Map<String, dynamic>>.empty(); // No user is signed in
    }
    DocumentSnapshot doc = await userDocRef.collection('events').doc(formattedDate).get();

    if (doc.exists) {
      //print("Document found: ${doc.data()}"); // Debugging print leave this for if things breaks

      List<Map<String, dynamic>> events = List<Map<String, dynamic>>.from(
        //reference the documentation above, this is very similar
          (doc.data() as Map<String, dynamic>)['events'] ?? []
      );

      // Sort events by time
      events.sort((a, b) {
        // cast the time maps from dynamic to Map<String, int>
        Map<String, int> timeA = Map<String, int>.from(a['time'] as Map<String, dynamic>);
        Map<String, int> timeB = Map<String, int>.from(b['time'] as Map<String, dynamic>);


        return (timeA['hour']! * 60 + timeA['minute']!) - (timeB['hour']! * 60 + timeB['minute']!);
      });

      return events;
    } else {
      print("No document found for date: $formattedDate"); // Debugging print
      return [];
    }
  }
}
