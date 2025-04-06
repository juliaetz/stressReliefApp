import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/selfcare_model.dart';
import 'package:stress_managment_app/view/selfcare_component.dart';
import 'package:stress_managment_app/view/selfcare_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SelfcarePresenter {
  void updatePage(int index){}
  void updateCurrentIdea(){}
  set selfcareView(SelfcareView value){}
}

class BasicSelfcarePresenter extends SelfcarePresenter{
  late SelfcareModel _viewModel;
  late SelfcareView _view;

  BasicSelfcarePresenter() {
    this._viewModel = SelfcareModel();
    updateDatabase();
    _loadPageIndex();
  }

  void _loadPageIndex() async {
    _viewModel.pageIndex = 0;
    //_view.updateSelectedIndex(_viewModel.pageIndex);
  }


  @override
  set selfcareView(SelfcareView value) {
    _view = value;
    //_view.updateSelectedIndex(_viewModel.pageIndex);
    initializeIdea();
    //updatePage(_viewModel.pageIndex);
  }

  void initializeIdea() async {
    await updateDatabase(); // Wait for ideas to load
    _viewModel.pageIndex = 0;

    int initialIdeaIndex = getRandomIndex();
    _viewModel.currentIdeaIndex = initialIdeaIndex;

    String idea = _viewModel.ideasList[initialIdeaIndex].get("Idea");
    _view.updateIdea(idea);

    _view.updateSelectedIndex(_viewModel.pageIndex);
    updatePage(_viewModel.pageIndex);
  }


  @override
  void updatePage(int index){
    if(index != _viewModel.pageIndex){
      _viewModel.pageIndex = index;
      _view.updateSelectedIndex(_viewModel.pageIndex);
    }

    Widget page;
    if(_viewModel.pageIndex == 0){
      page = _view.IdeasPage();
    } else {
      //page = FavoritesPage();
      page = _view.FavoritesPage();
    }

    _view.updatePage(page);
  }

  Future<void> updateDatabase()async{
    final QuerySnapshot snapshot = await _viewModel.ideasDatabaseReference.get();
    _viewModel.ideasList = snapshot.docs;
    _viewModel.databaseSize = _viewModel.ideasList.length;
  }

  int getRandomIndex(){
    Random random = new Random();
    int randomNumber = random.nextInt(_viewModel.ideasList.length);
    return randomNumber;
  }

  @override
  Future<void> updateCurrentIdea()async{
    if(_viewModel.ideasList.length != _viewModel.databaseSize){
      await updateDatabase();
    }

    int newIdeaIndex = getRandomIndex();
    _viewModel.currentIdeaIndex = newIdeaIndex;
    String idea = _viewModel.ideasList.elementAt(newIdeaIndex).get("Idea");
    _view.updateIdea(idea);
    updatePage(_viewModel.pageIndex);
  }

}