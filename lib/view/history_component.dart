import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stress_managment_app/view/mood_tracker_screen/mood_history_summary.dart';
import 'activity_bar.dart';
import 'history_view.dart';
import 'package:stress_managment_app/presenter/history_presenter.dart';
import 'homePage_view.dart';
import 'package:fl_chart/fl_chart.dart';
import '../firebase_logic.dart';

class HistoryPage extends StatefulWidget {
  final HistoryPresenter presenter;

  HistoryPage(this.presenter, {required Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}



class _HistoryPageState extends State<HistoryPage> implements HistoryView {
  @override
  void initState() {
    super.initState();
    this.widget.presenter.historyView = this;

  }

  //DELETE THIS BEFORE FINAL MERGE: TEST FUNCTION
  void fetchEventCounts() async {
    // Call the function that gets the event counts and logs them to the console
    Map<String, int> eventCounts = await widget.presenter.getEventCountsByDay();
    print("Event Counts: $eventCounts");
  }

  String _dropdownValue = 'Activity History';
  List<Widget> _entries = [];
  int _selectedIndex = 0;
  Widget _page = Placeholder();



  void handleHistoryValueChanged(String? value){
    this.widget.presenter.onOptionChanged(value!);
  }

  void updateScreen(){
    this.widget.presenter.updateScreen();
  }


  void handlePageChange(int index){
    setState((){
      _selectedIndex = index;

      if(index == 0){
        _page = DailyHistoryPage();
      }
      else if (index == 1){
        _page = ActivityGraph();
      }
      else if (index == 2){
        _page = MoodHistorySummary();
      }
    });
  }


  @override
  void updateEntries(List<Widget> entries){
    setState(() {
      _entries = entries;
    });
  }

  @override
  void updateSelectedIndex(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

    @override
    void updatePage(Widget page){
      setState(() {
        _page = page;
      });
    }


  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: buildHomeButton(),
        title: Text('Daily Activity and Mood History'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade200,
      ),

      body: Center(
        child: _page,
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple.shade700,
        iconSize: 30.0,

        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedFontSize: 23.0,
        selectedItemColor: Colors.white,

        unselectedIconTheme: IconThemeData(color: Colors.deepPurple.shade200),
        unselectedFontSize: 18.0,
        unselectedItemColor: Colors.white,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_sharp),
            label: 'Activity Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Mood Graph'
          )
        ],


        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            handlePageChange(index);
          });
        },
      ),
    );
  }

  // START OF FUNCTIONS RELATED TO HISTORY VIEW
  @override
  Container DailyHistoryPage(){
    return Container(
      width: double.infinity,
      decoration: addBackground(),

      child: Column(
        children: [
          historySelectionRow(),
          Padding(padding: EdgeInsets.all(10)),
          buildHistoryScrollable(),
        ],
      ),
    );
  }

  Row historySelectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(8)),
        Text('Daily History:  ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        DropdownButton<String>(
          value: _dropdownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          underline: Container(height: 2, color: Colors.deepPurple.shade700),
          items: <String>['Activity History', 'Mood History'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _dropdownValue = newValue!;
              handleHistoryValueChanged(newValue);
              updateScreen();
            });
          },
        ),
      ],
    );
  }


  Expanded buildHistoryScrollable() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: _entries,
        ),
      ),
    );
  }
  // END OF FUNCTIONS RELATED TO HISTORY VIEW


  // ACTIVITY GRAPH VIEW
  //going to need to call the getEventsByCoutns() for the map<string, int>
    @override
    Widget ActivityGraph() {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/purple_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<Map<String, int>>(
          future: getEventCountsByDay(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.values.every((count) => count == 0)) {
              return const Center(child: Text("No events found"));
            }

            // use the data for the chart
            final eventCounts = snapshot.data!;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 500, //constrains the chart's height, you get an error if you dont
                    child: ActivityBarChart(eventCounts: eventCounts),
                  ),
                ),
                const SizedBox(height: 12),
                const Text("Event activity by day"),
              ],
            );
          },
        ),
      );
    }




  // START OF MISC UI ELEMENTS
  FilledButton buildHomeButton() {
    return FilledButton(
      // HOME BUTTON TO RETURN TO HOME PAGE
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder:(context) => HomePage(),)
        );
      },

      child: Icon(Icons.house, color:Colors.white),
      style: FilledButton.styleFrom(
        shape: CircleBorder(side: BorderSide(color: Colors.deepPurple.shade200, width: 8)),
        padding: EdgeInsets.all(5),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.deepPurple.shade700,
      ),
    );
  }

  BoxDecoration addBackground() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/purple_background.jpg"),
        fit: BoxFit.fill,
      ),
    );
  }


  String _getWeekdayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday];
  }

  @override
  Future<Map<String, int>> getEventCountsByDay() async{
    //create a Map<String, int>, where the string is the day of the week, and the int is the number of event occurrences in our firebase
    //we will later be incrementing the int
    Map<String, int> dayCounts = {
      'Monday': 0,
      'Tuesday': 0,
      'Wednesday': 0,
      'Thursday': 0,
      'Friday':0,
      'Saturday':0,
      'Sunday':0
    };

    final userDocRef = await getUserDocument();
    final eventDatabaseReference = userDocRef.collection('events');
    QuerySnapshot snapshot = await eventDatabaseReference.get();

    //now loop through our fields in snapshot so we can increment the count for each day
    for (var doc in snapshot.docs) {

      try{
        //access the data in our 'date' (i dont think we need to format it)
        //We need to see every day that has an event, and then increment out dayCounts map by 1, based on the day/
        Timestamp timestamp = doc['date'];
        DateTime eventDate = timestamp.toDate();
        //determine day of the week string
        String weekday = _getWeekdayName(eventDate.weekday);

        List<dynamic> events = doc['events'];
        //get the length of the event field
        int numEvents = events.length;
        //if 'weekday' is in our map 'dayCount'
        if(dayCounts.containsKey(weekday)) {
          //increment weekday by + 1

          dayCounts[weekday] = dayCounts[weekday]! + numEvents;


        }

      } catch (e) {
        print('Error with data from doc ${doc.id}: $e');
      }
    }
    //return our incremented map
    return dayCounts;

  }

}