import 'package:flutter/material.dart';

class JournalModel{
    String text;
    DateTime timestamp;

    JournalModel ({
        required this.text,
        required this.timestamp,
    });

    Map<String, dynamic> toMap(){
        return{
            text: 'text',
            timestamp.toIso8601String(): 'timestamp'
        };
    }



}