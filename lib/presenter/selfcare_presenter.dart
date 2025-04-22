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
  void removeFavorite(String idea){}
  void makeUserFavorite(String idea){}
  void scheduleIdea(String idea, DateTime date, TimeOfDay time){}
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
    if(_viewModel.ideasList.length != _viewModel.databaseSize || _viewModel.filterType != "No Filter" || _viewModel.ideasList.length == 0){
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
      DocumentSnapshot doc = _viewModel.ideasList[_viewModel.currentIdeaIndex];
      String id = doc.id;
      swapFaveAndIdea(id, doc, _viewModel.favoritesDatabaseReference, _viewModel.ideasDatabaseReference);

      _viewModel.favoritesList.add(_viewModel.ideasList[_viewModel.currentIdeaIndex].get("Idea")); // adding the idea string

      _viewModel.mostRecentFave = _viewModel.ideasList.elementAt(_viewModel.currentIdeaIndex);
      _viewModel.ideasList.removeAt(_viewModel.currentIdeaIndex);

      _viewModel.heartIcon = Icons.favorite;
    } else {
      swapFaveAndIdea(_viewModel.mostRecentFave?.id, _viewModel.mostRecentFave, _viewModel.ideasDatabaseReference, _viewModel.favoritesDatabaseReference);
      _viewModel.favoritesList.removeLast();

      _viewModel.heartIcon = Icons.favorite_border;
    }

    updateAfterFavoritesHandle();
  }

  @override
  void removeFavorite(String idea) async {
    DocumentSnapshot? currDoc; // to get the current document
    await _viewModel.favoritesDatabaseReference.get().then((results){
      for(DocumentSnapshot docs in results.docs){
        if(docs.get("Idea") == idea){
          currDoc = docs;
        }
      }
    });
    String? id = currDoc?.id;
    swapFaveAndIdea(id, currDoc, _viewModel.ideasDatabaseReference, _viewModel.favoritesDatabaseReference);
    _viewModel.favoritesList.remove(idea);

    if(_viewModel.mostRecentFave?.get("Idea") == idea){
      _viewModel.heartIcon = Icons.favorite_border;
    }

    updateAfterFavoritesHandle();
  }


  void updateAfterFavoritesHandle(){
    updateDatabase();
    _view.updateHeartIcon(_viewModel.heartIcon);
    _view.updateFavorites(_viewModel.favoritesList);
    updatePage(_viewModel.pageIndex);
  }

  void swapFaveAndIdea(String? id, DocumentSnapshot? currDoc, CollectionReference refAdd, CollectionReference refRemove){
    refAdd.doc(id).set(
        {
          "Idea": currDoc?.get("Idea"),
          "Filter": currDoc?.get("Filter"),
        });

    refRemove.doc(id).delete();
  }

  @override
  void makeUserFavorite(String idea) async {
    _viewModel.favoritesDatabaseReference.doc().set(
      {
        "Idea": idea,
        "Filter": 'User made',
      });
    _viewModel.favoritesList.add(idea);

    _view.updateFavorites(_viewModel.favoritesList);
    updatePage(_viewModel.pageIndex);
  }


  @override
  void scheduleIdea(String idea, DateTime date, TimeOfDay time){
    String formattedDate = "${date.year}-${date.month}-${date.day}";
    Map<String, int> timeData = {'hour': time.hour, 'minute': time.minute};

    _viewModel.eventsDatabaseReference.doc(formattedDate).set({
      'date': Timestamp.fromDate(date),
      'events': FieldValue.arrayUnion([
        {'time': timeData, 'description': idea}
      ])
    }, SetOptions(merge: true));
  }
}