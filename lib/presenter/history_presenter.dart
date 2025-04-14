import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/history_model.dart';
import 'package:stress_managment_app/view/history_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

 abstract class HistoryPresenter {
  set historyView(HistoryView value){}
  void onOptionChanged(String value) {}
  void updateScreen(){}
  void createBlocks(CollectionReference database, String field){}
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
    _view.updateHistory(_viewModel.historyType);
  }

  @override
  set historyView(HistoryView value) {
    _view = value;
    _view.updateHistory(_viewModel.historyType);
  }

  @override
  void onOptionChanged(String value){
    if (value != _viewModel.historyType) {
      _viewModel.historyType = value;
      _view.updateHistory(_viewModel.historyType);
    }
  }

  @override
  Future<void> createBlocks(CollectionReference database, String field) async {
    final QuerySnapshot snapshot = await database.get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    documents.forEach((document) {
      var date = document.get("Date");
      var data = document.get(field);
      Container entry = createEntryContainer(date, field, data);
      _viewModel.entries.add(entry);
    });
  }

  Container createEntryContainer(date, String field, data) {
    return Container(
      decoration: BoxDecoration(color: Colors.white,),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      margin: EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$date', style: TextStyle(fontSize: 16),),
          Text('$field: $data', style: TextStyle(fontSize: 20),),
        ],
      ),
    );
  }

  @override
  Future<void> updateScreen() async{
    _viewModel.entries.clear();
    if(_viewModel.historyType == "Activity History"){
      await createBlocks(_viewModel.historyDatabaseReference, 'Activities');
      _view.updateEntries(_viewModel.entries);
    }
    else if (_viewModel.historyType == "Mood History"){
      await createBlocks(_viewModel.moodDatabaseReference, 'Mood');
      _view.updateEntries(_viewModel.entries);
    }
  }









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
    return days[weekday - 1];
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
    final eventDatabaseReference = FirebaseFirestore.instance.collection('events');
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
          print("Processing doc: ${doc.id} with data: ${doc.data()}");

          dayCounts[weekday] = dayCounts[weekday]! + numEvents;

          print("Event found on ${eventDate.toLocal()} (${weekday})");

        }

        print('Total docs fetched: ${snapshot.docs.length}');

      } catch (e) {
        print('Error with data from doc ${doc.id}: $e');
      }
    }
    //return our incremented map
    print("Final counts: $dayCounts");
    return dayCounts;

  }
}