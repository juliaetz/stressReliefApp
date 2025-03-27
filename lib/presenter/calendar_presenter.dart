//the presenter acts as a middle man between view and model
//it contains logic for handling user interactions and fetching data

import 'package:flutter/material.dart';

import '../model/calendar_model.dart';

class CalendarPresenter {
  final CalendarModel model; //model object

  CalendarPresenter(this.model); //constructor for model


  void deleteEvent(DateTime date, String event){
    model.deleteEvent(date, event);
  }

  bool isSameDay(DateTime? selectedDay, DateTime day) {
    return selectedDay != null &&
        selectedDay.year == day.year &&
        selectedDay.month == day.month &&
        selectedDay.day == day.day;
  }

  void onDaySelected(DateTime selectedDay) {
    //  settings a day/getting a day
    print("Selected Day: $selectedDay ");
  }

  void addEvent(DateTime date, String event, TimeOfDay time) {
    model.addEvent(date, event, time);
  }

  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    return model.getEventsForDay(day); //gets events from the model


  }
}
  



