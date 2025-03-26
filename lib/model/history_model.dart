//import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:async';

class HistoryModel{
  String _historyType = "Activity History";

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

  /*Future<int> loadValue() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? data = preferences.getInt('data');
    if( data != null ) {
      return data;
    } else {
      return 0;
    }

  }*/

  HistoryModel();
}