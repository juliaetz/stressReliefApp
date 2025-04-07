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
  void updateFilter(String value){}
  void updateFavoritesList(){}
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
    _viewModel.filterType = "No Filter";
    _viewModel.heartIcon = Icons.favorite_border;
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
    await createFavorites();
    _view.updateFavorites(_viewModel.favoritesList);
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
    final QuerySnapshot snapshot;
    if(_viewModel.filterType != "No Filter"){
      snapshot = await _viewModel.ideasDatabaseReference.where("Filter", isEqualTo: _viewModel.filterType).get();
    } else {
      snapshot = await _viewModel.ideasDatabaseReference.get();
    }
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
    if(_viewModel.ideasList.length != _viewModel.databaseSize || _viewModel.filterType != "No Filter"){
      await updateDatabase();
    }
    if(_viewModel.heartIcon != Icons.favorite_border){
      _viewModel.heartIcon = Icons.favorite_border;
      _view.updateHeartIcon(_viewModel.heartIcon);
    }

    String idea;
    if(_viewModel.ideasList.isEmpty){
      idea = "No more ideas under this filter";
    } else {
      int newIdeaIndex = getRandomIndex();
      _viewModel.currentIdeaIndex = newIdeaIndex;
      idea = _viewModel.ideasList.elementAt(newIdeaIndex).get("Idea");
      _viewModel.currentIdea = idea;
    }
    _view.updateIdea(idea);
    updatePage(_viewModel.pageIndex);
  }

  @override
  void updateFilter(String value)async{
    if(value != _viewModel.filterType){
      _viewModel.filterType = value;
      //filterDatabase(_viewModel.filterType);
    }
    _view.updateFilter(_viewModel.filterType);
    updateCurrentIdea();
  }

  Future<void> createFavorites() async {
    final QuerySnapshot snapshot = await _viewModel.favoritesDatabaseReference.get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    documents.forEach((document) {
      _viewModel.favoritesList.add(document.get("Idea"));
    });
  }

  @override
  void updateFavoritesList(){
    _viewModel.favoritesListWidgets.clear();
    if (_viewModel.heartIcon == Icons.favorite_border) {
      String id = _viewModel.ideasList[_viewModel.currentIdeaIndex].id;
      _viewModel.favoritesDatabaseReference.doc(id).set(
          {
            "Idea": _viewModel.ideasList[_viewModel.currentIdeaIndex].get("Idea"),
            "Filter": _viewModel.ideasList[_viewModel.currentIdeaIndex].get("Filter"),
          });
      _viewModel.ideasDatabaseReference.doc(id).delete();
      _viewModel.favoritesList.add(_viewModel.ideasList[_viewModel.currentIdeaIndex].get("Idea")); // adding the idea string

      _viewModel.mostRecentFave = _viewModel.ideasList.elementAt(_viewModel.currentIdeaIndex);
      _viewModel.ideasList.removeAt(_viewModel.currentIdeaIndex);

      _viewModel.heartIcon = Icons.favorite;
    } else {
      _viewModel.ideasDatabaseReference.doc(_viewModel.mostRecentFave?.id).set(
          {
            "Idea": _viewModel.mostRecentFave?.get("Idea"),
            "Filter": _viewModel.mostRecentFave?.get("Filter"),
          });

      _viewModel.favoritesDatabaseReference.doc(_viewModel.mostRecentFave?.id).delete();
      _viewModel.favoritesList.removeLast();

      _viewModel.heartIcon = Icons.favorite_border;
    }

    updateDatabase();
    _view.updateHeartIcon(_viewModel.heartIcon);
    _view.updateFavorites(_viewModel.favoritesList);
    updatePage(_viewModel.pageIndex);
  }
}