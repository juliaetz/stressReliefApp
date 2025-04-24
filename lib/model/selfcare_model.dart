import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stress_managment_app/firebase_logic.dart';

class SelfcareModel{
  int _pageIndex = 0;
  String _filterType = "No Filter";
  CollectionReference ideasDatabaseReference = FirebaseFirestore.instance.collection('Self_Care_Ideas');
  late CollectionReference favoritesDatabaseReference;
  int databaseSize = 0;
  int currentIdeaIndex = 0;
  String currentIdea = "";
  List<DocumentSnapshot> ideasList = [];
  DocumentSnapshot? mostRecentFave;
  List<String> favoritesList = [];
  List<Widget> favoritesListWidgets = [];
  IconData _heartIcon = Icons.favorite_border;

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

  IconData get heartIcon => _heartIcon;
  set heartIcon(IconData setValue){
    _heartIcon = setValue;
  }

  int get value2 => (_heartIcon == Icons.favorite_border)?0 : 1; // returns value. MPG is 0.
  set value2(int value){
    if(value == 0){
      _heartIcon = Icons.favorite_border;
    } else if (value == 1){
      _heartIcon = Icons.favorite;
    }
  }

  Future<void> initializeFavIdeasDatabaseRef() async {
    final userDocRef = await getUserDocument();
    favoritesDatabaseReference = userDocRef.collection('Favorite_Ideas');
  }
  SelfcareModel() {
    initializeFavIdeasDatabaseRef();
  }
}