import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stress_managment_app/firebase_logic.dart';

class HistoryModel{
  String _historyType = "Activity History";
  int _pageIndex = 0;
  late CollectionReference historyDatabaseReference;
  late CollectionReference moodDatabaseReference;
  late CollectionReference eventDatabaseReference;
  List<Widget> entries = [];

  // history type setter and getters
  String get historyType => _historyType;
  set historyType(String setValue){
    _historyType = setValue;
  }

  int get value => (_historyType == "Activity History")?0 : 1; // 0 is activity hist
  set value(int value){
    if(value == 0){
      _historyType = "Activity History";
    } else if (value == 1){
      _historyType = "Mood History";
    }
  }


  // page index setter and getters
  int get pageIndex => _pageIndex;
  set pageIndex(int setValue){
    _pageIndex = setValue;
  }

  int get value1 => (_pageIndex == 0)?0 : 1; // 0 is daily history page
  set value1(int value){
    if(value == 0){
      _pageIndex = 0;
    } else if (value == 1){
      _pageIndex = 1;
    }
  }

  Future<void> initializeUserDatabaseRefs() async {
    final userDocRef = await getUserDocument();
    historyDatabaseReference = userDocRef.collection('events');
    moodDatabaseReference = userDocRef.collection('Mood');
    eventDatabaseReference = userDocRef.collection('events');
  }
  HistoryModel() {
    initializeUserDatabaseRefs();
  }
}