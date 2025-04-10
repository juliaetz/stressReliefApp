import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/history_model.dart';
import 'package:stress_managment_app/view/history_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

class HistoryPresenter {
  set historyView(HistoryView value){}
  void onOptionChanged(String value) {}
  void updateScreen(){}
  void createBlocksActivity(){}
  void createBlocksMood(){}
  void updatePage(int index){}
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
}