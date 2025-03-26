// I THINK THIS IS FOR METHOD IMPLEMENTATION?


class CalendarModel {
  final Map<DateTime, List<String>> events; //this will store events for each date

  CalendarModel(this.events); // constructor

  //Map a DateTime to a List of strings, the strings will be the notes
  final Map<DateTime, List<String>> _events = {};


  //Method for add events to a specific day
  void addEvent(DateTime date, String event){

    if (!_events.containsKey(date)){  //check if the date is in the map
      _events[date] = [];   // if date not in map, initialize the map for that date
    }
    _events[date]!.add(event); //if already in map, add it to the string list for that date
  }

  List<String> getEventsForDay(DateTime date) {
    return _events[date] ?? [];
  }


}