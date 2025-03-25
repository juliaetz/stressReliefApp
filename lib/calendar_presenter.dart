//the presenter acts as a middle man between view and model
//it contains logic for handling user interactions and fetching data

import 'calendar_model.dart';

class CalendarPresenter {
  final CalendarModel model; //model object

  CalendarPresenter(this.model); //constructor for model

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

  List<String> getEventsForDay(DateTime day) {
    return model.getEventsForDay(day); //gets events from the model
  }
}




