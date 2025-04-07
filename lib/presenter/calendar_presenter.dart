//the presenter acts as a middle man between view and model
//it contains logic for handling user interactions and fetching data

import 'package:flutter/material.dart';
import '../model/calendar_model.dart';


class CalendarPresenter {
  final CalendarModel model; //model object

  CalendarPresenter(this.model); //constructor for model


  Future<void> addEvent(DateTime date, String event, TimeOfDay time) async {
    await model.addEvent(date, event, time);
  }

  Future<void> deleteEvent(DateTime date, String event) async {
    await model.deleteEvent(date, event);
  }

  Future<List<Map<String, dynamic>>> getEventsForDay(DateTime date) async {
    return await model.getEventsForDay(date);
  }
}




