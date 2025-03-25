import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_presenter.dart';
//this is the view, ideally rename this to planner_view

class CalendarView extends StatefulWidget {
  //The calender updates based on selection (stateful widget)

  final CalendarPresenter presenter; // stores the presenter instance

  const CalendarView({super.key, required this.presenter}); // constructor

  @override
  _CalendarViewState createState() => _CalendarViewState();
}


class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now(); // get the current day when the user opens the calender
  DateTime? _selectedDay; // get the day selected by the user

  @override
  Widget build(BuildContext Context) {
    return Scaffold(
        appBar: AppBar(title: Text('Planner')),
        body: Column(
          children: [
            TableCalendar(focusedDay: _focusedDay,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 1, 1))
          ],
        )
    );
  }

}