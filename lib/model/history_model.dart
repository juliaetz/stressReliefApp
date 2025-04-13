import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HistoryModel{
  String _historyType = "Activity History";
  int _pageIndex = 0;
  final historyDatabaseReference = FirebaseFirestore.instance.collection('events');
  final moodDatabaseReference = FirebaseFirestore.instance.collection('Mood');
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

  int get pageIndex => _pageIndex;
  set pageIndex(int setValue){
    _pageIndex = setValue;
  }

  int get value1 => (_pageIndex == 0)?0 : 1; // returns value. MPG is 0.
  set value1(int value){
    if(value == 0){
      _pageIndex = 0;
    } else if (value == 1){
      _pageIndex = 1;
    }
  }

  HistoryModel();
}