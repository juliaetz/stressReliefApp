import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/history_model.dart';
import 'package:stress_managment_app/presenter/mood_tracker_presenter.dart';
import 'package:stress_managment_app/view/history_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

abstract class HistoryPresenter {
  set historyView(HistoryView value){}
  void onOptionChanged(String value) {}
  void updateScreen(){}
  void createBlocksActivity(){}
  void createBlocksMood(){}
  void updatePage(int index){}
  Future<Map<String, int>> getEventCountsByDay();
}

class BasicHistoryPresenter extends HistoryPresenter{
  late HistoryModel _viewModel;
  late HistoryView _view;

  BasicHistoryPresenter() {
    this._viewModel = HistoryModel();
    _loadUnit();
  }

  void _loadUnit() async {
    _viewModel.historyType = "N/A";
    _viewModel.pageIndex = 0;
  }

  @override
  set historyView(HistoryView value) {
    _view = value;
    updatePage(_viewModel.pageIndex);
  }

  @override
  void onOptionChanged(String value){
    if (value != _viewModel.historyType) {
      _viewModel.historyType = value;
    }
  }

  // FUNCTIONS RELATED TO DISPLAYING HISTORY DATA
  @override
  Future<void> createBlocksActivity() async{
    final QuerySnapshot snapshot = await _viewModel.historyDatabaseReference.get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    documents.forEach((document) {
      var date = DateFormat('yMMMMd').format(document.get('date').toDate());
      List<dynamic> events = document.get("events");
      events.forEach((map) {
        var activity = map.values.first;
        var hour = map.values.last.values.first;
        var minute = map.values.last.values.last;

        // at some point I would like to find a better solution to switching from
        // military time to 12 hour time. I admit this is awful but it's what I
        // could come up with without using build context
        var tempDate = DateTime.parse('1969-07-20 01:01:04Z');
        if(minute < 10){
          tempDate = DateTime.parse('1969-07-20 $hour:0$minute:04Z');
        } else if (hour < 10){
          tempDate = DateTime.parse('1969-07-20 0$hour:$minute:04Z');
        } else if (minute < 10 && hour < 10){
          tempDate = DateTime.parse('1969-07-20 0$hour:0$minute:04Z');
        } else {
          tempDate = DateTime.parse('1969-07-20 $hour:$minute:04Z');
        }
        String time = DateFormat('h:mm a').format(tempDate);

        Container entry = createEntryContainer(date, "Activity", activity, time: time);
        _viewModel.entries.add(entry);
      });
    });
  }


  @override
  Future<void> createBlocksMood() async{
    final QuerySnapshot snapshot = await _viewModel.moodDatabaseReference.get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    documents.forEach((document) {
      var date = document.get("date").toString().substring(0,10);
      var data = document.get("mood");
      Container entry = createEntryContainer(date, "Mood", data);
      _viewModel.entries.add(entry);
    });
  }

  Container createEntryContainer(date, String field, data, {String time = ""}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white,),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      margin: EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$date $time', style: TextStyle(fontSize: 16),),
          Text('$field: $data', style: TextStyle(fontSize: 20),),
        ],
      ),
    );
  }

  @override
  Future<void> updateScreen() async{
    _viewModel.entries.clear();
    if(_viewModel.historyType == "Activity History"){
      await createBlocksActivity();
      _view.updateEntries(_viewModel.entries);
    }
    else if (_viewModel.historyType == "Mood History"){
      await createBlocksMood();
      _view.updateEntries(_viewModel.entries);
    }

    updatePage(_viewModel.pageIndex);
  }

  @override
  void updatePage(int index){
    int prevIndex = _viewModel.pageIndex;
    if(index != _viewModel.pageIndex){
      _viewModel.pageIndex = index;
      _view.updateSelectedIndex(_viewModel.pageIndex);
    }

    Widget page;
    List<Widget> pages = [_view.DailyHistoryPage(), _view.ActivityGraph()];
    if(_viewModel.pageIndex < 2) {
      page = pages.elementAt(_viewModel.pageIndex);
    } else {
      page = pages.elementAt(prevIndex);
    }

    _view.updatePage(page);
  }
  // END OF FUNCTIONS RELATED TO HISTORY DATA

//helper function to get the day of the week
  //
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

  //create a new method to get the event counts by day of the week
  //by using future we can fetch data without freezing the ui
  @override
  Future<Map<String, int>> getEventCountsByDay() async {
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

    //come back and change this line so that it fits with the 'event' field in our db
    final eventDatabaseReference = _viewModel.eventDatabaseReference;
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

        print("$numEvents event(s) on $weekday (${eventDate.toLocal()})");


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