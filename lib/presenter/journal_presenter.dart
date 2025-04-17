import 'package:flutter/cupertino.dart';

import '../model/journal_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class JournalPresenter{
    final List<JournalModel> entries = [];
    final FirebaseFirestore firestore;

    JournalPresenter({required this.firestore});


    /*Future<void> saveEntry(Text entry){

    }*/

    //creates a new journal entry
    void addEntry(String text){
        //creates a JournalModel object and adds it to the list
        JournalModel entry = JournalModel(text: text, date: DateTime.now().toString());
        entries.add(entry);

        //logs the journal entry being added, remove after testing is done
        print('Journal Entry Saved: ${entry.text} at ${entry.date}');

    }

    List<JournalModel> getEntries(){
        return entries;
    }

}