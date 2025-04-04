import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SelfcareModel{
  int pageIndex = 0;

  int get index => pageIndex;
  set selectedPageIndex(int setValue){
    pageIndex = setValue;
  }

  int get value => (pageIndex == 0)?0 : 1;
  set value(int value){
    if(value == 0){
      pageIndex = 0;
    } else if (value == 1){
      pageIndex = 1;
    }
  }


  SelfcareModel();
}