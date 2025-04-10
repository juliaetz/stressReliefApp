import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel{
  String _historyType = "Activity History";
  final historyDatabaseReference = FirebaseFirestore.instance.collection('Activities');
  final moodDatabaseReference = FirebaseFirestore.instance.collection('Mood');
  final eventDatabaseReference = FirebaseFirestore.instance.collection('events');
  List<Widget> entries = [];

  String get historyType => _historyType;
  set historyType(String setValue){
    _historyType = setValue;
  }

  int get value => (_historyType == "Activity History")?0 : 1; // returns value. MPG is 0.
  set value(int value){
    if(value == 0){
      _historyType = "Activity History";
    } else if (value == 1){
      _historyType = "Mood History";
    }
  }

  HistoryModel();
}