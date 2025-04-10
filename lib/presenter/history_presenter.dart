import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/history_model.dart';
import 'package:stress_managment_app/view/history_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stress_managment_app/view/mood_tracker_screen/mood_tracker_view.dart';

class HistoryPresenter {
  set historyView(HistoryView value){}
  void onOptionChanged(String value) {}
  void updateScreen(){}
  void createBlocks(CollectionReference database, String field){}
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
    _view.updateHistory(_viewModel.historyType);
    _viewModel.pageIndex = 0;
  }

  @override
  set historyView(HistoryView value) {
    _view = value;
    _view.updateHistory(_viewModel.historyType);
    updatePage(_viewModel.pageIndex);
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

  @override
  void updatePage(int index){
    if(index != _viewModel.pageIndex){
      _viewModel.pageIndex = index;
      _view.updateSelectedIndex(_viewModel.pageIndex);
    }

    Widget page;
    if(_viewModel.pageIndex == 0){
      page = _view.DailyHistoryPage();
      _viewModel.onMoodTracker = false;
    } else if(_viewModel.pageIndex == 1) {
      page = _view.ActivityGraph();
      _viewModel.onMoodTracker = false;
    } else {
      page = MoodTrackerView();
      _viewModel.onMoodTracker = true;
    }

    _view.updateOnMoodTracker(_viewModel.onMoodTracker);
    _view.updatePage(page);
  }
}