import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../presenter/calendar_presenter.dart';

//ISSUES IN VIEW:
//making calls to the firebase is REALLY slow and doesnt work a lot of time, we get this error:
//[ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: [cloud_firestore/unavailable]
//maybe firestore being down or too many requests made ?

class CalendarView extends StatefulWidget {
  final CalendarPresenter presenter;

  const CalendarView({super.key, required this.presenter});

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<Map<String, dynamic>> _events = []; // Store events for the selected day

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents(); // Load events for today's date initially
  }


  /// Fetches events from Firestore and updates the UI
  Future<void> _loadEvents() async {
    if (_selectedDay == null) return;
    List<Map<String, dynamic>> events = await widget.presenter.getEventsForDay(_selectedDay!);
    print("event print here: $events");
    setState(() {
      _events = events;
    });
    print("event 2 print here: $events");
  }

  @override
  Widget build(BuildContext context) {
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

              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },

              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _loadEvents(); // Load events when the user selects a new day
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
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }),

            ),

            Expanded(
              child: _events.isEmpty
                  ? Center(child: Text("No events for this day"))
                  : ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  var event = _events[index];

                  // Convert stored {hour, minute} into TimeOfDay
                  TimeOfDay time = TimeOfDay(
                      hour: event['time']['hour'], minute: event['time']['minute']);
                  String description = event['description'];

                  return ListTile(
                    title: Text(description),
                    subtitle: Text(time.format(context)), // Show event time
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        if (_selectedDay != null) {
                          await widget.presenter.deleteEvent(_selectedDay!, description);
                          _loadEvents(); // Reload events after deletion
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_selectedDay != null) {
              _showAddEventDialog(_selectedDay!);
            }
          },
          child: Icon(Icons.add),
        ));
  }

  /// Shows a dialog to add an event
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
              onPressed: () async {
                if (eventController.text.trim().isNotEmpty) {
                  await widget.presenter.addEvent(selectedDate, eventController.text, selectedTime);
                  _loadEvents(); // Refresh event list
                  Navigator.pop(context); // Close dialog after saving
                }
              },
              child: Text("Save"),
            ),
          ],
        ));
  }
}
