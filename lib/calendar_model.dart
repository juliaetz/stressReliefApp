// I THINK THIS IS FOR METHOD IMPLEMENTATION?


import 'package:flutter/material.dart';

class CalendarModel {
  final Map<DateTime, List<String>> events; //this will store events for each date

  CalendarModel(this.events); // constructor

  //Map a DateTime to a List of strings, the strings will be the notes
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};


  //method for remving an event from a day in the calendar
  void deleteEvent(DateTime date, String event){
    //look for the event we want to delete
    if(_events.containsKey(date)){

      _events[date]!.removeWhere((e) => e['description'] == event);
      if(_events[date]!.isEmpty){
        _events.remove(date);
      }
    }
  }


  //Method for add events to a specific day
  void addEvent(DateTime date, String event, TimeOfDay time){

    if (!_events.containsKey(date)){  //check if the date is in the map
      _events[date] = [];   // if date not in map, initialize the map for that date
    }

    //if already in map, add it to the string list for that date
    _events[date]!.add({'time': time, 'description': event});


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