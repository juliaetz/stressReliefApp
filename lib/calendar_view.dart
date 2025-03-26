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
  CalendarFormat _calendarFormat = CalendarFormat.month;



  @override
  Widget build(BuildContext Context) {





    return Scaffold(
        appBar: AppBar(title: Text('Planner')),
        body: Column(



          children: [
            TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 1, 1),

                // Dynamic Calendar Format
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },

              selectedDayPredicate: (day ) {
                  return isSameDay(_selectedDay, day);
              },

              onDaySelected: (selectedDay, focusedDay) {
                  setState(() {

                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _showAddEventDialog(selectedDay);
              },

              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, _) {
                  return Container(
                    margin: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
                todayBuilder: (context, date, _) {
                  return Container(
                    margin: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent, //the green highlight refers to the current day
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }
              ),

              )


          ],
        )
    );


  }

  void _showAddEventDialog(DateTime selectedDate) {
    TextEditingController eventController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
      title: Text("Add Note for ${selectedDate.toLocal()}".split(' ')[0]),
      content: TextField(
        controller: eventController,
        decoration: InputDecoration(hintText: "Enter event or note"),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context); //close dialog without saving
            },
            child: Text("Cancel")
        ),
        TextButton(
            onPressed: () {
              setState(() {
                widget.presenter.addEvent(selectedDate, eventController.text);
              });
              Navigator.pop(context); //closes dialog after saving
            },
            child: Text("save"),
        )
      ],
    ));

  }

}