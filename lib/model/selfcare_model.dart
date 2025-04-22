import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SelfcareModel{
  int _pageIndex = 0;
  String _filterType = "No Filter";
  final ideasDatabaseReference = FirebaseFirestore.instance.collection('Self_Care_Ideas');
  final favoritesDatabaseReference = FirebaseFirestore.instance.collection('Favorite_Ideas');
  final eventsDatabaseReference = FirebaseFirestore.instance.collection('events');
  int databaseSize = 0;
  int currentIdeaIndex = 0;
  String currentIdea = "";
  List<DocumentSnapshot> ideasList = []; // list of ideas the page can randomly generate
  DocumentSnapshot? mostRecentFave;
  List<String> favoritesList = []; // strings of favorite ideas, view uses this to display favorites
  IconData _heartIcon = Icons.favorite_border;

  // pageIndex setter and getter
  int get pageIndex => _pageIndex;
  set pageIndex(int setValue){
    _pageIndex = setValue;
  }

  int get value => (_pageIndex == 0)?0 : 1; // 0 is ideas page
  set value(int value){
    if(value == 0){
      _pageIndex = 0;
    } else if (value == 1){
      _pageIndex = 1;
    }
  }


  // filter setter and getter
  String get filterType => _filterType;
  set filterType(String setValue){
    _filterType = setValue;
  }

  int get value1 => (_filterType == "No Filter")?0 : 1; // 0 is no filter
  set value1(int value){
    if(value == 0){
      _filterType = "No Filter";
    } else if (value == 1){
      _filterType = "Filter";
    }
  }


  // heart icon setter and getter
  IconData get heartIcon => _heartIcon;
  set heartIcon(IconData setValue){
    _heartIcon = setValue;
  }

  int get value2 => (_heartIcon == Icons.favorite_border)?0 : 1; // 0 is unfavorited
  set value2(int value){
    if(value == 0){
      _heartIcon = Icons.favorite_border;
    } else if (value == 1){
      _heartIcon = Icons.favorite;
    }
  }

  SelfcareModel();
}