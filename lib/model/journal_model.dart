import 'package:flutter/material.dart';

class JournalModel{
    final Map<DateTime, List<String>> entries;
    JournalModel (this.entries);
    final Map<DateTime, List<Map<String, dynamic>>> _entries = {};

    void addEntry(String text, DateTime date, TimeOfDay time){

    }

    void deleteEntry(DateTime date, String entry){

    }

    void getEntries(){

    }
}