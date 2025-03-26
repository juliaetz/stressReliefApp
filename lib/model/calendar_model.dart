// I THINK THIS IS FOR METHOD IMPLEMENTATION?


class CalendarModel {
  final Map<DateTime, List<String>> events; //this will store events for each date

  CalendarModel(this.events); // constructor

  List<String> getEventsForDay(DateTime day){
    return events[day] ?? []; //returns a list of events for a specific day
  }

}