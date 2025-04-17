import 'package:flutter/material.dart';

class JournalModel{
    final String text;
    final String date;

    JournalModel ({
        required this.text,
        required this.date,
    });

    Map<String, dynamic> toMap(){
        return{
            'text': text,
            'date': date,
        };
    }

    static JournalModel fromMap(Map<String, dynamic> map){
        return JournalModel(
            text: map['text'],
            date: map['timestamp'],
        );
    }



}