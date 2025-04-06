import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SelfcareModel{
  int _pageIndex = 0;
  String _filterType = "No Filter";
  final ideasDatabaseReference = FirebaseFirestore.instance.collection('Self_Care_Ideas');
  int databaseSize = 0;
  int currentIdeaIndex = 0;
  List<DocumentSnapshot> ideasList = [];

  int get pageIndex => _pageIndex;
  set pageIndex(int setValue){
    _pageIndex = setValue;
  }

  int get value => (_pageIndex == 0)?0 : 1; // returns value. MPG is 0.
  set value(int value){
    if(value == 0){
      _pageIndex = 0;
    } else if (value == 1){
      _pageIndex = 1;
    }
  }


  String get filterType => _filterType;
  set filterType(String setValue){
    _filterType = setValue;
  }

  int get value1 => (_filterType == "No Filter")?0 : 1; // returns value. MPG is 0.
  set value1(int value){
    if(value == 0){
      _filterType = "No Filter";
    } else if (value == 1){
      _filterType = "Filter";
    }
  }

  SelfcareModel();
}