import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//this is pretty much a complete overhaul of the previous calendar_model
//this version removed the prevoous map<DateTime, map<<Events> <TimeOfDay>>> because we couldnt convert DateTime to
//a format that could be stored in our firebase


class CalendarModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Adds an event to Firestore
  Future<void> addEvent(DateTime date, String event, TimeOfDay time) async {
    String formattedDate = _formatDate(date);

    // Convert TimeOfDay to a map
    Map<String, int> timeData = {'hour': time.hour, 'minute': time.minute};

    //A DocumentReference refers to a document location in our FirebaseFirestore
    // database and can be used to write, read, or listen to the location.
    DocumentReference docRef = _firestore.collection('events').doc(formattedDate);


    //wait to receive our date, events, and time
    await docRef.set({
      'date': Timestamp.fromDate(date),
      'events': FieldValue.arrayUnion([
        {'time': timeData, 'description': event}
      ])
    }, SetOptions(merge: true));
  }

  // Removes an event from Firestore
  Future<void> deleteEvent(DateTime date, String event) async {
    String formattedDate = _formatDate(date);
    DocumentReference docRef = _firestore.collection('events').doc(formattedDate);

    // Fetch current events
    DocumentSnapshot doc = await docRef.get();
    if (doc.exists) {
      List<dynamic> events = (doc.data() as Map<String, dynamic>)['events'] ?? [];

      // Remove the event with the matching description
      events.removeWhere((e) => e['description'] == event);

      // Update Firestore (delete the doc if empty)
      if (events.isEmpty) {
        await docRef.delete();
      } else {
        await docRef.update({'events': events});
      }
    }
  }

  // Retrieves events for a specific date from Firestore
  Future<List<Map<String, dynamic>>> getEventsForDay(DateTime date) async {
    String formattedDate = _formatDate(date);
    DocumentSnapshot doc = await _firestore.collection('events').doc(formattedDate).get();

    if (doc.exists) {
      List<Map<String, dynamic>> events = List<Map<String, dynamic>>.from(
          (doc.data() as Map<String, dynamic>)['events'] ?? []);

      // Sort events by time
      events.sort((a, b) {
        Map<String, int> timeA = a['time'];
        Map<String, int> timeB = b['time'];

        return (timeA['hour']! * 60 + timeA['minute']!) - (timeB['hour']! * 60 + timeB['minute']!);
      });

      return events;
    } else {
      return [];
    }
  }

  // Formats DateTime as a string for Firestore doc IDs
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }
}
