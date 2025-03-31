import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../presenter/calendar_presenter.dart';

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
        appBar: AppBar(
            title: Text('Planner'),
            backgroundColor: Colors.deepPurple.shade200,
        ),
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

              ),
            Expanded(
              child: ListView(
                children: widget.presenter.getEventsForDay(_selectedDay ?? DateTime.now()).map((event) {

                  TimeOfDay time = event['time'];
                  String description = event['description'];

                  return ListTile(
                    title: Text(description),
                    subtitle: Text(time.format(context)), // Show the event's time
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        if (_selectedDay != null) { // Ensure _selectedDay is not null
                          setState(() {
                            widget.presenter.deleteEvent(_selectedDay!, description);
                          });
                        }
                      },
                    ),
                  );
                                }).toList(),
              ),
            ),


          ],
        )
    );


  }


  //ADD SOME FUNCTIONLAITY THAT CHECKS THAT THE EVENTS ARE PROPERLY BEING SAVED
  //idk print the date and event value pairs ?

  void _showAddEventDialog(DateTime selectedDate) {
    TextEditingController eventController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

     showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Add Event for ${selectedDate.toLocal()}".split(' ')[0]),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: eventController,
            decoration: InputDecoration(hintText: "Enter event description"),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: selectedTime,
              );
              if (pickedTime != null) {
                setState(() {
                  selectedTime = pickedTime;
                });
              }
            },
            child: Text("Select Time: ${selectedTime.format(context)}"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog without saving
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.presenter.addEvent(selectedDate, eventController.text, selectedTime);
            });
            Navigator.pop(context); // Close dialog after saving
          },
          child: Text("Save"),
        ),
      ],
    ));

  }

}