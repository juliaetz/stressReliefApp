import 'package:flutter/material.dart';

abstract class HistoryView{
  void updateEntries(List<Widget> entries){}
  Container DailyHistoryPage(){return Container();}
  Widget ActivityGraph(){return Container();}
  void updateSelectedIndex(int index){}
  void updatePage(Widget page){}
  Future<Map<String, dynamic>> getEventCountsByDay();

}