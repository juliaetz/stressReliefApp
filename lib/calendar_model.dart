// I THINK THIS IS FOR METHOD IMPLEMENTATION?


import 'package:flutter/material.dart';

class CalendarModel {
  final Map<DateTime, List<String>> events; //this will store events for each date

  CalendarModel(this.events); // constructor

  //Map a DateTime to a List of strings, the strings will be the notes
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};


  //Method for add events to a specific day
  void addEvent(DateTime date, String event, TimeOfDay time){

    if (!_events.containsKey(date)){  //check if the date is in the map
      _events[date] = [];   // if date not in map, initialize the map for that date
    }

    _events[date]!.add({'time': time, 'description': event});
    //if already in map, add it to the string list for that date


    _events[date]!.sort((a,b) {
      TimeOfDay timeA = a['time'];
      TimeOfDay timeB = b['time'];
      return (timeA.hour * 60 + timeA.minute) - (timeB.hour * 60 + timeB.minute);
    });
  }




  List<Map<String, dynamic>> getEventsForDay(DateTime date) {
    return _events[date] ?? [];
  }


}